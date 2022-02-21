FROM node:16-alpine

RUN apk update

# 💡 https://stackoverflow.com/questions/40944479/docker-how-to-use-bash-with-an-alpine-based-docker-image
RUN apk add bash

# These are dependencies needed for parcel
RUN apk add g++
RUN apk add make
RUN apk add python3
RUN ln -sf python3 /usr/bin/python

RUN npm install -g npm@8.4.1

COPY ./scripts/bootstrapWebsite.sh ./bootstrap.sh
RUN chmod +x bootstrap.sh

# 💡 https://stackoverflow.com/questions/14219092/bash-script-and-bin-bashm-bad-interpreter-no-such-file-or-directory
RUN sed -i -e 's/\r$//' bootstrap.sh

WORKDIR /avalon-project/ui
COPY ./templates/client/website/ui/package.json .
RUN npm install
RUN mv ./node_modules ../../node_modules

COPY ./templates/client/website /avalon-project

WORKDIR /

# 💡 https://stackoverflow.com/questions/37904682/how-do-i-use-docker-environment-variable-in-entrypoint-array
ENTRYPOINT ["/bin/bash", "-c", "exec ./bootstrap.sh ${@}", "--"];
