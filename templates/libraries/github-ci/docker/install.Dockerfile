FROM node:16-alpine

ENV TERM xterm-256color

WORKDIR /{{projectName}}/library

COPY ./library/package.json .

COPY ./library/package-lock.json .

RUN npm ci --silent

RUN mv ./node_modules ../../node_modules

CMD ["echo", ""]
