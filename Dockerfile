# Build environment
FROM alpine:latest as build
RUN apk update
RUN apk add --no-cache --update python3 py3-pip bash

# Install dependencies
RUN mkdir /tmp
COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Build app
COPY webapp/. /opt
WORKDIR /opt/webapp

# Run the image as a non-root user
# RUN adduser -D app-user
# USER app-user

# Expose is NOT supported by Heroku
# EXPOSE 80

# Run the app. CMD is required to run on Heroku
# $PORT is set by Heroku			
# CMD gunicorn --bind 0.0.0.0:$PORT wsgi 

