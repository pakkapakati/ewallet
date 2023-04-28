#!/bin/bash
docker build -t pakkapakati/ewallet-rest-api .
docker push pakkapakati/ewallet-rest-api

ssh deploy@$DEPLOY_SERVER << EOF
docker pull pakkapakati/ewallet-rest-api
docker stop api-ewallet || true
docker rm api-ewallet || true
docker rmi pakkapakati/ewallet-rest-api:current || true
docker tag pakkapakati/ewallet-rest-api:latest pakkapakati/ewallet-rest-api:current
docker run -d --restart always --name api-ewallet -p 3000:3000 pakkapakati/ewallet-rest-api:current
EOF
