from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from uuid import UUID
from app.dependencies.db import get_db
from app.dependencies.auth import get_current_user
from app.models.models import InterviewSession, SessionAnswer, InterviewCategory, User
from app.schemas.history import SessionSummary, SessionDetailResponse, AnswerDetail

router = APIRouter()

@router.get("/", response_model=List[SessionSummary])
def get_history(
    limit: int = 10,
    offset: int = 0,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    sessions = db.query(InterviewSession).filter(
        InterviewSession.user_id == current_user.id
    ).order_by(InterviewSession.created_at.desc()).offset(offset).limit(limit).all()

    results = []
    for s in sessions:
        category = db.query(InterviewCategory).filter(InterviewCategory.id == s.category_id).first()
        results.append(SessionSummary(
            id=s.id,
            date=s.created_at,
            title=category.title if category else "Unknown",
            score=s.overall_score,
            is_completed=s.is_completed
        ))
    return results

@router.get("/{session_id}", response_model=SessionDetailResponse)
def get_session_details(
    session_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    session = db.query(InterviewSession).filter(
        InterviewSession.id == session_id,
        InterviewSession.user_id == current_user.id
    ).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    category = db.query(InterviewCategory).filter(InterviewCategory.id == session.category_id).first()
    answers = db.query(SessionAnswer).filter(SessionAnswer.session_id == session.id).all()

    answer_details = []
    for a in answers:
        answer_details.append(AnswerDetail(
            question_text=a.question.text if a.question else "Question removed",
            user_answer=a.user_answer,
            score=a.score,
            strengths=a.feedback_json.get("strengths", []),
            weaknesses=a.feedback_json.get("weaknesses", []),
            model_answer=a.feedback_json.get("model_answer", "")
        ))

    return SessionDetailResponse(
        id=session.id,
        overall_score=session.overall_score,
        category_title=category.title if category else "Unknown",
        created_at=session.created_at,
        answers=answer_details
    )
