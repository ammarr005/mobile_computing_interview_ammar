from sqlalchemy.orm import Session
from app.models.models import InterviewCategory, InterviewQuestion

def seed_db(db: Session):
    # Check if categories already exist
    if db.query(InterviewCategory).first():
        return

    categories = [
        {"title": "HR Interview", "subtitle": "Behavioral & Fit", "icon_key": "groups"},
        {"title": "Software Engineering", "subtitle": "Algorithms & Systems", "icon_key": "code"},
        {"title": "AI / ML", "subtitle": "Models & Data", "icon_key": "psychology"},
        {"title": "Data Science", "subtitle": "Stats & Analysis", "icon_key": "storage"},
        {"title": "Product Management", "subtitle": "Strategy & Execution", "icon_key": "view_kanban"},
        {"title": "General Interview", "subtitle": "Standard Practice", "icon_key": "chat_bubble"},
    ]

    for cat_data in categories:
        category = InterviewCategory(**cat_data)
        db.add(category)
        db.flush()  # To get category id

        # Add mock questions for each category
        questions = [
            {"text": f"Tell me about a challenge you faced in {cat_data['title']}.", "hint": "Use the STAR method."},
            {"text": "Why are you interested in this role?", "hint": "Connect your background to the company mission."},
            {"text": "Where do you see yourself in five years?", "hint": "Talk about growth and skill development."},
        ]

        for q_data in questions:
            question = InterviewQuestion(category_id=category.id, **q_data)
            db.add(question)

    db.commit()
