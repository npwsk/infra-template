FROM node:16.16.0
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build
