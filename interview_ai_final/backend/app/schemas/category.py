from pydantic import BaseModel

class CategoryBase(BaseModel):
    title: str
    subtitle: str
    icon_key: str

class CategoryResponse(CategoryBase):
    id: int

    class Config:
        from_attributes = True
