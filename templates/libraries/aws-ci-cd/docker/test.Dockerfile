FROM node:16-alpine

RUN npm install -g npm@8.4.1

ENV TERM xterm-256color

WORKDIR /{{projectName}}

COPY ./library .

ENTRYPOINT ["npm", "run", "test"]

CMD ["."]
