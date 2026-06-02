import google.generativeai as genai
import json
import re
from app.core.config import settings

class GeminiService:
    def __init__(self):
        if settings.GEMINI_API_KEY:
            genai.configure(api_key=settings.GEMINI_API_KEY)
            self.model = genai.GenerativeModel('gemini-pro')
        else:
            self.model = None

    async def evaluate_answer(self, category: str, question: str, answer: str):
        if not self.model:
            return {
                "score": 0,
                "strengths": ["API Key missing"],
                "weaknesses": ["Evaluation skipped"],
                "model_answer": "Please configure Gemini API Key."
            }

        prompt = f"""
        Act as a Senior Recruiter and Interviewer for {category}.
        Evaluate the candidate's answer to the following question.

        Question: {question}
        Candidate's Answer: {answer}

        Provide feedback in JSON format exactly as follows:
        {{
            "score": <integer 0-100>,
            "strengths": [<string>, <string>, <string>],
            "weaknesses": [<string>, <string>],
            "model_answer": <string version using STAR method>
        }}

        Return ONLY the JSON object.
        """

        try:
            response = self.model.generate_content(prompt)
            text = response.text
            # Use regex to find the JSON part in case of extra text
            match = re.search(r'\{.*\}', text, re.DOTALL)
            if match:
                return json.loads(match.group())
            return json.loads(text)
        except Exception as e:
            print(f"Gemini Error: {e}")
            return {
                "score": 0,
                "strengths": ["AI Service error"],
                "weaknesses": ["Evaluation failed"],
                "model_answer": f"Error: {str(e)}"
            }

gemini_service = GeminiService()
