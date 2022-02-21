#!/bin/bash

RED="\033[0;31m";
GREEN="\033[0;32m";
BLUE="\033[0;34m";
END_COLOR="\033[0m";

function avalog() {
  message=${1};

  echo -e "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${message}";
}

function bootstrap() {
  AWS_DEFAULT_REGION=${1};
  AWS_ACCESS_KEY_ID=${2};
  AWS_SECRET_ACCESS_KEY=${3};
  AWS_SESSION_TOKEN=${4};

  if [[ -z ${AWS_DEFAULT_REGION} ]]
  then
    avalog "${RED}AWS default region not found. Make sure to assume the appropiate role and pass its credentials to this script.${END_COLOR}";
    exit 1;
  elif [[ -z ${AWS_ACCESS_KEY_ID} ]]
  then
    avalog "${RED}AWS access key not found. Make sure to assume the appropiate role and pass its credentials to this script.${END_COLOR}";
    exit 1;
  elif [[ -z ${AWS_SECRET_ACCESS_KEY} ]]
  then
    avalog "${RED}AWS secret access key not found. Make sure to assume the appropiate role and pass its credentials to this script.${END_COLOR}";
    exit 1;
  elif [[ -z ${AWS_SESSION_TOKEN} ]]
  then
    avalog "${RED}AWS session token not found. Make sure to assume the appropiate role and pass its credentials to this script.${END_COLOR}";
    exit 1;
  fi

  avalog "${GREEN}📦 Preparing to release...${END_COLOR}";

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
    --file ${dockerFilePath} \
    --tag ${imageName} \
    .;

  # Run the "release project" command container.
  docker container run \
    --rm \
    -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
    --name ${containerName} \
    ${imageName};
}

bootstrap $@;
