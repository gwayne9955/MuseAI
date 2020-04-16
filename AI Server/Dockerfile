FROM python:3.6-buster

# Create app directory
WORKDIR /usr/src/app

ENV FLASK_APP melody-ai-server.py
ENV FLASK_RUN_HOST 0.0.0.0

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# COPY package*.json ./


# RUN apk add --no-cache gcc musl-dev linux-headers
RUN apt-get update
RUN yes | apt-get install libsndfile1
# RUN pip install pysndfile
# RUN pip install SoundFile
# RUN pip install tensorflow
# RUN pip install keras
# RUN pip3 install sndfile
RUN pip3 install magenta
RUN pip3 install flask
# RUN pip install redis
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 5000

# CMD [ "node", "melody-ai-server.js" ]
# CMD [ "python3", "melody-ai-server.py" ]

CMD [ "flask", "run" ]