FROM node:16-alpine

RUN npm install -g npm@8.4.1

ENV TERM xterm-256color

ARG NPM_AUTH_TOKEN

WORKDIR /{{projectName}}

COPY ./library .

RUN npm set //npm.pkg.github.com/:_authToken $NPM_AUTH_TOKEN

RUN if [[ -f "package-lock.json" ]] ; then npm ci --silent ; else npm install ; fi

RUN npm run build

CMD ["npm", "run", "release"]