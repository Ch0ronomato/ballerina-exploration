FROM python:3.7

ADD ./requirements.txt requirements.txt
RUN ["pip", "install", "-r", "requirements.txt"]

ADD ./main.py main.py

ENTRYPOINT ["python"]
CMD ["main.py"]
