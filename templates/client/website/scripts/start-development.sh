#!/bin/bash

GREEN="\033[0;32m";
END_COLOR="\033[0m";

function avalog() {
  message=${1};

  echo -e "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${message}";
}

function bootstrap() {
  avalog "${GREEN}🔥 Starting project in development mode...${END_COLOR}";

  # ███████╗███████╗████████╗██╗   ██╗██████╗ 
  # ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
  # ███████╗█████╗     ██║   ██║   ██║██████╔╝
  # ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
  # ███████║███████╗   ██║   ╚██████╔╝██║     
  # ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

  projectName="{{projectName}}";
  imageName="${projectName}-development-image";
  dockerFilePath="./docker/start-development.Dockerfile";
  containerName="${projectName}-development-container";
  sourceCodePath="$(pwd)/ui";
  sourceCodePathWorkdir="/${projectName}";

  # Node modules volume.
  nodeModulesVolumeName="${projectName}-node_modules";
  nodeModulesContainerPath="/${projectName}/node_modules";

  # ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
  # ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
  # █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
  # ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
  # ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
  # ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

  # Pre-execution cleanup.
  docker container rm ${containerName} &> /dev/null;

  # Create an image to run a "start development mode" command.
  docker image build \
    --file ${dockerFilePath} \
    --tag ${imageName} \
    .;

  # Run the "start development mode" command container.
  docker container run \
    --rm \
    --interactive \
    --tty \
    -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
    -v ${sourceCodePath}:${sourceCodePathWorkdir} \
    --publish 8080:8080 \
    --name ${containerName} \
    ${imageName};
}

bootstrap $@;