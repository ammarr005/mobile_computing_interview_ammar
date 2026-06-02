import os
from dotenv import load_dotenv
from pydantic_settings import BaseSettings

load_dotenv()

class Settings(BaseSettings):
    PROJECT_NAME: str = os.getenv("PROJECT_NAME", "Interview Pro")
    SECRET_KEY: str = os.getenv("SECRET_KEY", "7d9c82f1b3e4d5c6a7b8c9d0e1f2a3b4")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 1440
    DATABASE_URL: str = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@db:5432/interview_db")
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")

settings = Settings()
