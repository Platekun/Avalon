FROM node:16-alpine

ENV TERM xterm-256color

RUN apk update && apk add git

WORKDIR /{{projectName}}

COPY ./library .

CMD ["npm", "run", "test:watch"]
