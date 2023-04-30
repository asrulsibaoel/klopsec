# from https://github.com/flmu/mlflow-tracking-server

FROM python:3.7

WORKDIR /app
COPY requirements.txt /app

RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt --upgrade

ENV PORT 5000

ENV FILE_DIR /tmp/mlflow

RUN mkdir -p /opt/mlflow

COPY run.sh /opt/mlflow
RUN chmod -R 777 /opt/mlflow/

EXPOSE $PORT

ENTRYPOINT ["/opt/mlflow/run.sh"]