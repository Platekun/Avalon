#!/bin/bash

# Note: Make sure you have `AVALON_PATH` as an environment variable in your shell profile. It must be an absolute path that points to this directory.

RED="\e[31m";
GREEN="\e[32m";
BLUE="\e[34m";
ENDCOLOR="\e[0m";

AVALON_VERSION=0.0.1;

# License
currentYear=(date +"%Y");
authorName=$(whoami);

assertArtifactType() {
    artifactType=$1

    if [[ $artifactType != "library" && $artifactType != "application" ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}An unsupported artifact type '${2}' was provided. Avalon only supported ${GREEN}'library'${ENDCOLOR} ${RED}or${ENDCOLOR} ${GREEN}'app'${ENDCOLOR} ${RED}as artifact types${ENDCOLOR}.");
        exit 1;
    fi
}

assertArtifactName() {
    artifactName=$1

    if [[ -z $artifactName ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}A name for the library is required.${ENDCOLOR}");
        exit 1;
    fi
}

handleUnknownCommand() {
    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}Command not supported. Try using ${GREEN}'avalon help'${ENDCOLOR} ${RED}command. ${ENDCOLOR}");
    exit 1;
}

createLibrary() {
    # ███████╗███████╗████████╗██╗   ██╗██████╗ 
    # ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
    # ███████╗█████╗     ██║   ██║   ██║██████╔╝
    # ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
    # ███████║███████╗   ██║   ╚██████╔╝██║     
    # ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

    artifactName=$1;
    ci=$2;
    imageName="$artifactName-image";
    dockerfilePath="$AVALON_PATH/docker/libraries/$ci.Dockerfile";
    containerName="$artifactName-container";

    # Node modules volume
    nodeModulesVolumeName="$artifactName-node_modules";
    nodeModulesContainerPath="/node_modules";

    # Source Code
    sourceVolumeName="$artifactName-source";
    sourceCodeContainerPath="/avalon-project";

    # ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
    # ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
    # █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
    # ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
    # ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
    # ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Bootstrapping a new TypeScript library...${ENDCOLOR}");

    # Pre-execution cleanup
    docker container rm "$containerName" &> /dev/null;
    docker volume rm "$sourceVolumeName" &> /dev/null;
    docker image rm "$imageName" &> /dev/null;

    echo "$dockerfilePath $imageName $AVALON_PATH"

    # Create an image to run a "create library" command.
    docker image build \
        --build-arg PROJECT_NAME=$artifactName \
        --build-arg YEAR=2021 \
        --build-arg AUTHOR_NAME=$authorName \
        --file $dockerfilePath \
        --tag "$imageName" \
        $AVALON_PATH || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.");
            exit 1;
        };

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
        };

    # Copy the contents of the source code volume into a new `library` directory.
    docker cp "$containerName":"$sourceCodeContainerPath" "./$artifactName" || \
    { 
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.");
        exit 1;
    };

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Cleaning up...${ENDCOLOR}");

    # Post-execution cleanup
    docker volume rm "$sourceVolumeName" &> /dev/null;
    docker container rm "$containerName" &> /dev/null;
    docker image rm "$imageName" &> /dev/null;

    cd $artifactName;
    git init;
    git add --all;
    git commit -m "Initial commit from Avalon v$AVALON_VERSION"
    cd ..;
}

createLibraryWithNoCi() {
    createLibrary $1 $2;

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
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!";

    printf "$successMessage";
    exit 0;
}

createLibraryWithGitHubCi() {
    createLibrary $1 $2;

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

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!";

    printf "$successMessage";
    exit 0;
}

createNewArtifact() {
    artifactName=$2;

    # Defaults.
    artifactType="library";
    ci="github-ci";

    for option in "$@"
    do
        case "$option" in
            "--artifact=library") artifactType="library";;
            "--ci=barebones") ci="no-ci";;
            "--ci=github-actions") ci="github-ci";;
            "--"*) exit 2;; # TODO: Add a nicer error message.
        esac
    done

    assertArtifactName $artifactName;
    assertArtifactType $artifactType;

    if [ $artifactType == "library" ]
    then
        if [ $ci == "no-ci" ]
        then
            createLibraryWithNoCi $artifactName $ci;
        elif [ $ci == "github-ci" ]
        then
            createLibraryWithGitHubCi $artifactName $ci;
        fi
    fi
}

execute() {
    topLevelCommand=$1;

    case $topLevelCommand in
        new) createNewArtifact $@;;
        *) handleUnknownCommand;;
    esac
}

execute $@;
