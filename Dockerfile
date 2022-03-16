###########################
# Build environment
###########################

# Get minimal base image
FROM alpine:latest as build
RUN apk update
RUN apk add --no-cache --update python3 py3-pip bash

# Prevents Python from writing pyc files to disc (equivalent to python -B option)
# ENV PYTHONDONTWRITEBYTECODE 1

# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
# UNBUFFERED let us know all the log on console if the app crashed  
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY app/requirements.txt /tmp/
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Build app
COPY app /opt/app/
WORKDIR /opt/app

# Run the image as a non-root user
RUN adduser -D app-user
USER app-user

###########################
# Production environment
###########################

# WEBSITES_PORT is set in Azure App Service Configuration > Application Setting
EXPOSE $WEBSITES_PORT
CMD gunicorn --bind 0.0.0.0:$WEBSITES_PORT wsgi

###########################
# Docker Desktop
###########################
# sudo chmod 666 /var/run/docker.sock
