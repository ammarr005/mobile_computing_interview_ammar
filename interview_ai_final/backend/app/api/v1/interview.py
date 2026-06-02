from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from uuid import UUID
from app.dependencies.db import get_db
from app.dependencies.auth import get_current_user
from app.models.models import InterviewSession, InterviewQuestion, InterviewCategory, SessionAnswer, User
from app.schemas.interview import (
    InterviewStartRequest, InterviewStartResponse, QuestionResponse,
    InterviewEvaluateRequest, InterviewEvaluateResponse,
    InterviewFinishRequest, InterviewFinishResponse
)
from app.services.gemini_service import gemini_service

router = APIRouter()

@router.post("/start", response_model=InterviewStartResponse, status_code=status.HTTP_201_CREATED)
def start_interview(
    request: InterviewStartRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    category = db.query(InterviewCategory).filter(InterviewCategory.id == request.category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    session = InterviewSession(
        user_id=current_user.id,
        category_id=request.category_id
    )
    db.add(session)
    db.commit()
    db.refresh(session)

    questions = db.query(InterviewQuestion).filter(InterviewQuestion.category_id == request.category_id).all()

    return {
        "session_id": session.id,
        "questions": questions
    }

@router.post("/evaluate", response_model=InterviewEvaluateResponse)
async def evaluate_answer(
    request: InterviewEvaluateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    session = db.query(InterviewSession).filter(
        InterviewSession.id == request.session_id,
        InterviewSession.user_id == current_user.id
    ).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    question = db.query(InterviewQuestion).filter(InterviewQuestion.id == request.question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")

    category = db.query(InterviewCategory).filter(InterviewCategory.id == session.category_id).first()

    # Call Gemini API
    ai_feedback = await gemini_service.evaluate_answer(
        category=category.title,
        question=question.text,
        answer=request.user_answer
    )

    # Save answer and feedback
    new_answer = SessionAnswer(
        session_id=session.id,
        question_id=request.question_id,
        user_answer=request.user_answer,
        score=ai_feedback["score"],
        feedback_json={
            "strengths": ai_feedback["strengths"],
            "weaknesses": ai_feedback["weaknesses"],
            "model_answer": ai_feedback["model_answer"]
        }
    )
    db.add(new_answer)
    db.commit()

    return InterviewEvaluateResponse(
        score=ai_feedback["score"],
        strengths=ai_feedback["strengths"],
        weaknesses=ai_feedback["weaknesses"],
        model_answer=ai_feedback["model_answer"]
    )

@router.post("/finish", response_model=InterviewFinishResponse)
def finish_interview(
    request: InterviewFinishRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    session = db.query(InterviewSession).filter(
        InterviewSession.id == request.session_id,
        InterviewSession.user_id == current_user.id
    ).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    answers = db.query(SessionAnswer).filter(SessionAnswer.session_id == session.id).all()
    if not answers:
        overall_score = 0
    else:
        overall_score = sum(a.score for a in answers) // len(answers)

    session.overall_score = overall_score
    session.is_completed = True
    db.commit()

    return {
        "overall_score": overall_score,
        "status": "completed"
    }
