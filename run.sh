#!/bin/bash

# Note: Make sure you have `AVALON_PATH` as an environment variable in your shell profile. It must be an absolute path that points to this directory.

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

if [[ ${1} != "new" ]] ; then
    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}Command not supported. Try using ${GREEN}'avalon help'${ENDCOLOR} ${RED}command. ${ENDCOLOR}")
    exit 0;
fi

projectName=$3

# License
currentYear=(date +"%Y")
authorName=$(whoami)

if [[ ${2} != "barebones-library" && ${2} != "app" ]] ; then
    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}An unsupported artifact type '${2}' was provided. Avalon only supported ${GREEN}'library'${ENDCOLOR} ${RED}or${ENDCOLOR} ${GREEN}'app'${ENDCOLOR} ${RED}as artifact types${ENDCOLOR}.")
    exit 0;
else [ ${2} == "barebones-library" ]
    if [[ -z ${3} ]] ; then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}A name for the library is required.${ENDCOLOR}")
        exit 0;
    fi

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Bootstrapping a new TypeScript library...${ENDCOLOR}")

    # ███████╗███████╗████████╗██╗   ██╗██████╗ 
    # ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
    # ███████╗█████╗     ██║   ██║   ██║██████╔╝
    # ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
    # ███████║███████╗   ██║   ╚██████╔╝██║     
    # ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

    imageName="$projectName-image"
    dockerfilePath="$AVALON_PATH/Dockerfile"
    containerName="$projectName-container"

    # Node modules volume
    nodeModulesVolumeName="$projectName-node_modules"
    nodeModulesContainerPath="/node_modules"

    # Source Code
    sourceVolumeName="$projectName-source"
    sourceCodeContainerPath="/avalon-project"

    # ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
    # ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
    # █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
    # ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
    # ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
    # ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

    # Pre-execution cleanup
    docker container rm "$containerName" &> /dev/null
    docker volume rm "$sourceVolumeName" &> /dev/null
    docker image rm "$imageName" &> /dev/null

    # Create an image to run a "create library" command.
    docker image build \
        --build-arg PROJECT_NAME=$projectName \
        --build-arg YEAR=2021 \
        --build-arg AUTHOR_NAME=$authorName \
        --tag "$imageName" \
        $AVALON_PATH || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.");
            exit 1;
        }

    # Run the "create library" command container.
    docker container run \
        --interactive \
        --tty \
        -v "$nodeModulesVolumeName":"$nodeModulesContainerPath" \
        -v "$sourceVolumeName":"$sourceCodeContainerPath" \
        --name "$containerName" \
        "$imageName" \
        || {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while running a 'create library' container command.");
            exit 1;
        }

    # Copy the contents of the source code volume into a new `library` directory.
    docker cp "$containerName":"$sourceCodeContainerPath" "./$projectName" || \
    { 
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.");
        exit 1;
    }

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Cleaning up...${ENDCOLOR}")

    # # Post-execution cleanup
    docker volume rm "$sourceVolumeName" &> /dev/null
    docker container rm "$containerName" &> /dev/null
    docker image rm "$imageName" &> /dev/null

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Success!${ENDCOLOR} Bootstrapped ${3} at $(pwd)/${3}.")

    successMessage="
    ℹ️  Inside that directory, you can run several commands from the ${BLUE}scripts${ENDCOLOR} directory:

        ${BLUE}install${ENDCOLOR}
        Installs the library dependencies (AKA your node_modules).

        ${BLUE}start-development${ENDCOLOR}
        Compiles your source code using the TypeScript compiler (🌐 https://www.npmjs.com/package/typescript) and re-compiles on changes.

        ${BLUE}test${ENDCOLOR}
        Starts the test runner (💡 You can use a custom test file path).

        ${BLUE}watch-tests${ENDCOLOR}
        Starts the test runner and watches for changes (💡 You can use a custom test file path).

        ${BLUE}format${ENDCOLOR}
        Formats your source code using Prettier (🌐 https://prettier.io).

        ${BLUE}build${ENDCOLOR}
        Compiles your source code using the TypeScript compiler (🌐 https://www.npmjs.com/package/typescript).

        ${BLUE}deploy${ENDCOLOR}
        Prompts your npm (🌐 https://www.npmjs.com) credentials to publish your package.

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${3}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!
"

    printf "$successMessage"
    exit 0;
fi
