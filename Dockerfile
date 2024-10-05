FROM python:3.8-slim

USER root

ENV PYTHONUNBUFFERED True

WORKDIR /app
COPY . /app

COPY ./requirements.txt ./requirements.txt


# uncomment for local developement setup.
#ENV GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/serviceAccount.json"


# pandas installed from ubuntu repos to avoid building C extensions
RUN pip install -r requirements.txt

COPY get_secret.py /app/get_secret.py
COPY entry-point.sh /app/entry-point.sh
COPY mlflow_auth.py /app/mlflow_auth.py

ENTRYPOINT ["/usr/bin/env", "bash", "/app/entry-point.sh"]

EXPOSE 8080

#ENTRYPOINT mlflow server --host 0.0.0.0 --port 8080