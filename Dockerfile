# Build environment
FROM alpine:latest as build
RUN apk update
RUN apk add --no-cache --update python3 py3-pip bash

# Prevents Python from writing pyc files to disc (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1

# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY app/requirements.txt /tmp/
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Build app
COPY app /opt/app/
WORKDIR /opt/app


###########################################
# Manual deploy if no auto port binding
###########################################

# Run the image as a non-root user
RUN adduser -D app-user
USER app-user

# Expose is NOT supported by Heroku
# EXPOSE 80

# Run the app. CMD is required to run on Heroku
# $PORT is set by Heroku			
# CMD gunicorn --bind 0.0.0.0:$PORT wsgi 
