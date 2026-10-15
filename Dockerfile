FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY train.py app.py ./
COPY templates ./templates
RUN python train.py
ENV MODEL_VERSION=1.0
EXPOSE 5000
CMD ["python", "app.py"]
