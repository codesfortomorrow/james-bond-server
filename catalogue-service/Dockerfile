FROM node:16
WORKDIR /app

RUN npm install pm2 --location=global
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
#CMD [ "npm", "start" ]
CMD ["pm2-runtime", "src/server.js", "--name", "catalogue-service", "--wait-ready", "--listen-timeout 60000", "--kill-timeout", "60000"]