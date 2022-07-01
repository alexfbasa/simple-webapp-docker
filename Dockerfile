FROM ubuntu:16.04

RUN apt-get update && apt-get install -y python python-pip && \
    apt-get -y install python-setuptools && apt-get install -y python-dev -y



RUN pip install --upgrade pip

RUN pip install flask

COPY app.py /opt/

ENTRYPOINT FLASK_APP=/opt/appy.py flask run --host=0.0.0.0