FROM python:3.9.10

RUN apt update 

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
ENTRYPOINT python hello.py
