#!/bin/bash

RED="\e[31m";
GREEN="\e[32m";
BLUE="\e[34m";
ENDCOLOR="\e[0m";

NPM_AUTH_TOKEN=${1};

if [[ -z ${NPM_AUTH_TOKEN} ]]
then
  echo $(printf "${RED}Authorization token not found. Create a valid authorization token and store it in the project's secrets as NPM_AUTH_TOKEN. Read more at https://docs.npmjs.com/creating-and-viewing-access-tokens.${ENDCOLOR}");
  exit 1;
fi

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}📦 Preparing to release...${ENDCOLOR}");

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}";
imageName="${projectName}-release-image";
dockerFilePath="./docker/release.Dockerfile";
containerName="${projectName}-release-container";

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

# Create an image to run a "release project" command.
docker image build \
  --build-arg NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN} \
  --file ${dockerFilePath} \
  --tag ${imageName} \
  .;

# Run the "release project" command container.
docker container run \
  --rm \
  --name ${buildContainerName} \
  ${imageName};
