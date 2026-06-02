from pydantic import BaseModel
from typing import List, Optional
from uuid import UUID

class InterviewStartRequest(BaseModel):
    category_id: int

class QuestionResponse(BaseModel):
    id: int
    text: str
    hint: Optional[str] = None

    class Config:
        from_attributes = True

class InterviewStartResponse(BaseModel):
    session_id: UUID
    questions: List[QuestionResponse]

class InterviewEvaluateRequest(BaseModel):
    session_id: UUID
    question_id: int
    user_answer: str

class InterviewEvaluateResponse(BaseModel):
    score: int
    strengths: List[str]
    weaknesses: List[str]
    model_answer: str

class InterviewFinishRequest(BaseModel):
    session_id: UUID

class InterviewFinishResponse(BaseModel):
    overall_score: int
    status: str
