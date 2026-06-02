from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from app.api.v1 import auth, interview, categories, profile, history
from app.db.session import engine, SessionLocal
from app.models.models import Base
from app.db.seed import seed_db

# Create tables
Base.metadata.create_all(bind=engine)

# Seed database on startup
db = SessionLocal()
try:
    seed_db(db)
finally:
    db.close()

app = FastAPI(title="Interview Pro API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(categories.router, prefix="/categories", tags=["Categories"])
app.include_router(interview.router, prefix="/interview", tags=["Interview"])
app.include_router(history.router, prefix="/history", tags=["History"])
app.include_router(profile.router, prefix="/profile", tags=["Profile"])

@app.get("/")
def read_root():
    return {"status": "online", "message": "Interview Pro API is running"}
