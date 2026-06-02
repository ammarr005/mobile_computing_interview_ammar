FROM python:3.11-slim

WORKDIR /code

# Install system dependencies for psycopg2
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app
COPY ./.env /code/.env

# Create empty __init__.py files to ensure packages are recognized
RUN touch /code/app/__init__.py /code/app/api/__init__.py /code/app/api/v1/__init__.py /code/app/core/__init__.py /code/app/db/__init__.py /code/app/models/__init__.py /code/app/schemas/__init__.py /code/app/services/__init__.py /code/app/dependencies/__init__.py

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
