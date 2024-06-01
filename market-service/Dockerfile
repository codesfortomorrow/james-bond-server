FROM node:16
WORKDIR /app

RUN npm install pm2 --location=global
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
EXPOSE 8001
#CMD [ "npm", "start" ]
CMD ["pm2-runtime", "app.js", "--name", "market-service", "--wait-ready", "--listen-timeout 60000", "--kill-timeout", "60000"]
