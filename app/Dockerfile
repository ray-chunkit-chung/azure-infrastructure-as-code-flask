###########################
# Build environment
###########################

# Get minimal base image
FROM python:latest as build
# RUN apk update
# RUN apk add --no-cache --update python3 py3-pip bash python3-dev libc-dev gcc

#######################################################################################
# Prevents Python from writing pyc files to disc (equivalent to python -B option)
# Python will no longer write these files to disk, and your development environment will remain nice and clean
#######################################################################################
# ENV PYTHONDONTWRITEBYTECODE 1

#######################################################################################
# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
# python output is sent straight to terminal (e.g. your container log) without being first buffered
# you can see the output of your application (e.g. django logs) in real time.
# This also ensures that no partial output is held in a buffer somewhere and never written in case the python application crashes.
#######################################################################################
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY flaskapp/requirements.txt /tmp/
RUN pip install --upgrade pip
RUN pip install -r /tmp/requirements.txt
# RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt


###########################
# Production environment
###########################

# Build app
# WORKDIR /opt/app
# COPY app /opt/app/

# Run the image as a non-root user
# RUN adduser -D app-user
# USER app-user

# Expose is NOT supported by Heroku
# EXPOSE 80

# Run the app. CMD is required to run on Heroku
# $PORT is set by Heroku			
# CMD gunicorn --bind 0.0.0.0:$PORT wsgi 
