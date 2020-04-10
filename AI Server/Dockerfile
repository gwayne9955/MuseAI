FROM python:3.7-alpine

# Create app directory
WORKDIR /usr/src/app

ENV FLASK_APP melody-ai-server.py
ENV FLASK_RUN_HOST 0.0.0.0

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# COPY package*.json ./


RUN apk add --no-cache gcc musl-dev linux-headers
# RUN pip install pysndfile
# RUN pip install SoundFile
# RUN pip install tensorflow
# RUN pip install keras
# RUN pip install magenta
RUN pip install flask
RUN pip install redis
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 5000

# CMD [ "node", "melody-ai-server.js" ]
# CMD [ "python3", "melody-ai-server.py" ]

CMD [ "flask", "run" ]