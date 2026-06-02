import uuid
from sqlalchemy import Column, String, Integer, ForeignKey, Text, Boolean, DateTime, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.base import Base

class User(Base):
    __tablename__ = "users"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    full_name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    avatar_url = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    sessions = relationship("InterviewSession", back_populates="user")

class InterviewCategory(Base):
    __tablename__ = "interview_categories"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, unique=True, nullable=False)
    subtitle = Column(String)
    icon_key = Column(String)
    questions = relationship("InterviewQuestion", back_populates="category")

class InterviewQuestion(Base):
    __tablename__ = "interview_questions"
    id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer, ForeignKey("interview_categories.id"))
    text = Column(Text, nullable=False)
    hint = Column(Text)
    category = relationship("InterviewCategory", back_populates="questions")

class InterviewSession(Base):
    __tablename__ = "interview_sessions"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    category_id = Column(Integer, ForeignKey("interview_categories.id"))
    overall_score = Column(Integer, default=0)
    is_completed = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    user = relationship("User", back_populates="sessions")
    answers = relationship("SessionAnswer", back_populates="session")

class SessionAnswer(Base):
    __tablename__ = "session_answers"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id = Column(UUID(as_uuid=True), ForeignKey("interview_sessions.id"))
    question_id = Column(Integer, ForeignKey("interview_questions.id"))
    user_answer = Column(Text, nullable=False)
    score = Column(Integer)
    feedback_json = Column(JSON) # {strengths: [], weaknesses: [], model_answer: ""}
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    session = relationship("InterviewSession", back_populates="answers")
    question = relationship("InterviewQuestion")
