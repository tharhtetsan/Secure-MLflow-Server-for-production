FROM python:3.8-slim

ENV PYTHONUNBUFFERED True

WORKDIR /app
COPY . /app

COPY ./requirements.txt ./requirements.txt

# pandas installed from ubuntu repos to avoid building C extensions
RUN pip install -r requirements.txt

COPY get_secret.py /app/get_secret.py
COPY entry-point.sh /app/entry-point.sh
COPY mlflow_auth.py /app/mlflow_auth.py



ENV GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/serviceAccount.json"


ENTRYPOINT ["/usr/bin/env", "bash", "/app/entry-point.sh"]

EXPOSE 8080