# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7
# Use the official Python and Node.js image
FROM ubuntu:22.04

RUN apt-get update

# Installing Node
RUN apt-get install --yes curl
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential

# Installing Python
RUN apt-get update && apt-get install -y python3.11 python3.11-dev python3-pip

# Set working directory
WORKDIR /app

# Copy setup.sh into the container
COPY . /app/

# # Make setup.sh executable
RUN chmod +x docker/setup.sh
RUN /bin/bash docker/setup.sh all

# Install python dependencies
RUN pip install -r requirements.txt

# Install app dependencies
RUN npm ci --omit=dev

# Bundle app source
COPY . .

# Expose port
EXPOSE 3000

# Use production node environment by default
ENV NODE_ENV production

# Run the application
CMD ["npm", "start"]

# Run setup.sh to install necessary tools
# RUN setup.sh