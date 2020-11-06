#!/bin/bash

cd $HOME/rotom_bot
git pull

docker build . -t rotom_bot:latest
docker stop rotom_bot
docker run --env-file .env --name rotom_bot --rm -d rotom_bot:latest
docker image prune -f
