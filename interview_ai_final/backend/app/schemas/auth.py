from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from uuid import UUID

class UserRegister(BaseModel):
    full_name: str = Field(..., min_length=1)
    email: EmailStr
    password: str = Field(..., min_length=6)

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class UserResponse(BaseModel):
    id: UUID
    email: EmailStr
    full_name: str

    class Config:
        from_attributes = True

class ForgotPassword(BaseModel):
    email: EmailStr
