FROM node:16-alpine

RUN npm install -g npm@8.4.0

ENV TERM xterm-256color

RUN apk update && apk add git

WORKDIR /{{projectName}}

COPY ./library .

CMD ["npm", "run", "test:watch"]
