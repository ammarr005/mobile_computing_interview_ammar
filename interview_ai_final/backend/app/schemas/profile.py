from pydantic import BaseModel, EmailStr
from typing import Optional

class UserStats(BaseModel):
    total_sessions: int
    avg_score: int
    current_streak: int

class ProfileResponse(BaseModel):
    full_name: str
    email: EmailStr
    stats: UserStats

class ProfileUpdate(BaseModel):
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None
