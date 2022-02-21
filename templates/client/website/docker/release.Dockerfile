FROM node:16-alpine as build
RUN npm install -g npm@8.4.1
WORKDIR /{{projectName}}
COPY ./ui .
RUN if [[ -f "package-lock.json" ]] ; then npm ci --silent ; else npm install ; fi
RUN npm run build

FROM amazonlinux:latest
WORKDIR /{{projectName}}
COPY --from=build /{{projectName}} .
RUN yum -y install aws-cli
ENV AWS_DEFAULT_REGION="" 
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_SESSION_TOKEN=""
CMD ["aws", "s3", "cp", "dist", "s3://{{projectName}}-bucket", "--recursive"]
