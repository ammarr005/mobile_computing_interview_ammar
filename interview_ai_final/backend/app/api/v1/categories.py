from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.dependencies.db import get_db
from app.models.models import InterviewCategory
from app.schemas.category import CategoryResponse
from app.dependencies.auth import get_current_user

router = APIRouter()

@router.get("/", response_model=List[CategoryResponse])
def get_categories(db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    return db.query(InterviewCategory).all()
