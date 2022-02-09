FROM node:16-alpine

RUN npm install -g npm@8.4.1

WORKDIR /avalon-project/library
COPY ./templates/libraries/aws-ci-cd/library/package.json .
RUN npm install --silent
RUN mv ./node_modules ../../node_modules

ARG PROJECT_NAME
ARG YEAR
ARG AUTHOR_NAME
ARG AWS_NPM_AUTH_TOKEN_SECRET_ARN

COPY ./templates/libraries/aws-ci-cd /avalon-project
RUN sed -i "s/{{year}}/${YEAR}/" LICENSE
RUN sed -i "s/{{authorName}}/${AUTHOR_NAME}/" LICENSE

WORKDIR /avalon-project
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" .avaloncli.json
RUN sed -i "s/{{npmAuthTokenArn}}/${AWS_NPM_AUTH_TOKEN_SECRET_ARN}/" "aws/buildspec.cd.yml"

WORKDIR /avalon-project/docker
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" install.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" start-development.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" build.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" test.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" watch-tests.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" format.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" ci.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" release.Dockerfile

WORKDIR /avalon-project/scripts
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" install.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" start-development.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" build.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" test.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" watch-tests.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" format.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" ci.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" release.sh

WORKDIR /avalon-project/library
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" package.json
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" package-lock.json

CMD ["echo", "🐳"]
