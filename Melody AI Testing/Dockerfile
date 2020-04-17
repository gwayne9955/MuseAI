FROM python:3.6-buster

WORKDIR /usr/src/app

RUN pip3 install flask

# ENV FLASK_ENV development

COPY . .

EXPOSE 5000

CMD [ "python3", "test.py" ]