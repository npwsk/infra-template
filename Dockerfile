FROM node:16.16.0-alpine

# couchbase sdk requirements
RUN apk update && apk add yarn curl bash python g++ make && rm -rf /var/cache/apk/*

WORKDIR /app

COPY . .

RUN npm ci && npm run build
