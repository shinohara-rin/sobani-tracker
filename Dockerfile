FROM node:13

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

EXPOSE 3000/udp

CMD ["node", "app.js"]
