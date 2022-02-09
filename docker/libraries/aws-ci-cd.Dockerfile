FROM node:16-alpine

# 💡 https://stackoverflow.com/questions/40944479/docker-how-to-use-bash-with-an-alpine-based-docker-image
RUN apk update && apk add bash
RUN npm install -g npm@8.4.1

COPY ./scripts/createLibraryWithAwsCiCd.sh .
RUN chmod +x createLibraryWithAwsCiCd.sh

# 💡 https://stackoverflow.com/questions/14219092/bash-script-and-bin-bashm-bad-interpreter-no-such-file-or-directory
RUN sed -i -e 's/\r$//' createLibraryWithAwsCiCd.sh

WORKDIR /avalon-project/library
COPY ./templates/libraries/aws-ci-cd/library/package.json .
RUN npm install --silent
RUN mv ./node_modules ../../node_modules

COPY ./templates/libraries/aws-ci-cd /avalon-project

WORKDIR /

# 💡 https://stackoverflow.com/questions/37904682/how-do-i-use-docker-environment-variable-in-entrypoint-array
ENTRYPOINT ["/bin/bash", "-c", "exec ./createLibraryWithAwsCiCd.sh ${@}", "--"];
