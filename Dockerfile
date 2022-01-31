FROM node:16-alpine

WORKDIR /avalon-project/library
COPY ./templates/barebones-library/library/package.json .
RUN npm install --silent
RUN mv ./node_modules ../../node_modules

ARG PROJECT_NAME
ARG YEAR
ARG AUTHOR_NAME

COPY ./templates/barebones-library /avalon-project
RUN sed -i "s/{{year}}/${YEAR}/" LICENSE
RUN sed -i "s/{{authorName}}/${AUTHOR_NAME}/" LICENSE

WORKDIR /avalon-project/docker
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" install.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" start-development.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" build.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" test.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" watch-tests.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" format.Dockerfile
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" deploy.Dockerfile

WORKDIR /avalon-project/scripts
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" install.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" start-development.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" build.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" test.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" watch-tests.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" format.sh
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" deploy.sh

WORKDIR /avalon-project/library
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" package.json
RUN sed -i "s/{{projectName}}/${PROJECT_NAME}/" package-lock.json

CMD ["echo", ""]
