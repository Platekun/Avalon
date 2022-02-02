FROM node:16-alpine

ENV TERM xterm-256color

WORKDIR /{{projectName}}

COPY ./library .

ENTRYPOINT ["npm", "run", "test"]

CMD ["."]
