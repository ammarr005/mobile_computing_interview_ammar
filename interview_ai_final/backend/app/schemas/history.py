from pydantic import BaseModel
from typing import List, Optional
from uuid import UUID
from datetime import datetime

class SessionSummary(BaseModel):
    id: UUID
    date: datetime
    title: str
    score: int
    is_completed: bool

    class Config:
        from_attributes = True

class AnswerDetail(BaseModel):
    question_text: str
    user_answer: str
    score: int
    strengths: List[str]
    weaknesses: List[str]
    model_answer: str

class SessionDetailResponse(BaseModel):
    id: UUID
    overall_score: int
    category_title: str
    created_at: datetime
    answers: List[AnswerDetail]
