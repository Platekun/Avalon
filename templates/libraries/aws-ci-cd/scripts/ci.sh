#!/bin/bash

GREEN="\033[0;32m";
END_COLOR="\033[0m";

function avalog() {
  message=${1};

  echo -e "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${message}";
}

function bootstrap() {
  avalog "${GREEN}🏗⠀⠀Building project...${END_COLOR}";

  # ███████╗███████╗████████╗██╗   ██╗██████╗ 
  # ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
  # ███████╗█████╗     ██║   ██║   ██║██████╔╝
  # ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
  # ███████║███████╗   ██║   ╚██████╔╝██║     
  # ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

  projectName="{{projectName}}";
  imageName="${projectName}-ci-image";
  dockerFilePath="./docker/ci.Dockerfile";
  containerName="${projectName}-ci-container";

  # ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
  # ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
  # █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
  # ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
  # ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
  # ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

  # Create an image to run a "install project" command.
  docker image build \
    --file ${dockerFilePath} \
    --tag ${imageName} \
    .;

  # Run the "Execute test runner" command container.
  docker container run \
    --rm \
    --tty \
    --name ${containerName} \
    ${imageName};
}

bootstrap $@;
