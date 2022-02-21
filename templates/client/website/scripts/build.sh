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
  imageName="${projectName}-build-image";
  dockerFilePath="./docker/build.Dockerfile";
  containerName="${projectName}-build-container";
  sourceCodePath="$(pwd)/ui";
  sourceCodePathWorkdir="/${projectName}";

  # Node modules volume.
  nodeModulesVolumeName="${projectName}-node_modules";
  nodeModulesContainerPath="/node_modules";

  # ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
  # ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
  # █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
  # ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
  # ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
  # ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

  # Pre-execution cleanup.
  docker container rm ${containerName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  # Create an image to run a "build project" command.
  docker image build \
    --file ${dockerFilePath} \
    --tag ${imageName} \
    .;

  # Run the "build project" command container.
  docker container run \
    --rm \
    --tty \
    -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
    -v ${sourceCodePath}:${sourceCodePathWorkdir} \
    --name ${containerName} \
    ${imageName};

  # Post-execution cleanup.
  docker image rm ${imageName} &> /dev/null;
}

bootstrap $@;