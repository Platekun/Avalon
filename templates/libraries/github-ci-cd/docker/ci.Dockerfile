FROM node:16-alpine

ENV TERM xterm-256color

WORKDIR /{{projectName}}

COPY ./library .

RUN if [[ -f "package-lock.json" ]] ; then npm ci --silent ; else npm install ; fi

ENTRYPOINT ["npm", "run", "test"]

CMD ["."]
