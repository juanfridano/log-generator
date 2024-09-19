FROM python:3.9-slim

WORKDIR /app

COPY logger.py /app

CMD ["python", "logger.py"]
