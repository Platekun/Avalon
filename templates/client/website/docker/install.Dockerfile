FROM node:16-alpine

RUN npm install -g npm@8.4.1

# These are dependencies needed for parcel
RUN apk add g++
RUN apk add make
RUN apk add python3
RUN ln -sf python3 /usr/bin/python

ENV TERM xterm-256color

WORKDIR /{{projectName}}/ui

COPY ./ui/package.json .

COPY ./ui/package-lock.json .

RUN npm install --silent

RUN mv ./node_modules ../../node_modules

CMD ["echo", ""]
