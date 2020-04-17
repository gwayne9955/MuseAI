FROM python:3.6-buster

# Create app directory
WORKDIR /usr/src/app

ENV FLASK_APP melody-ai-server.py
ENV FLASK_RUN_HOST 0.0.0.0
ARG FLASK_ENV="production"
ENV FLASK_ENV="${FLASK_ENV}" \
    PYTHONUNBUFFERED="true"

RUN apt-get update
RUN yes | apt-get install libsndfile1
RUN pip3 install magenta
RUN pip3 install flask
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 5000

# CMD [ "python3", "melody-ai-server.py" ]

CMD [ "flask", "run" ]