#!/bin/bash

# Note: Make sure you have `AVALON_PATH` as an environment variable in your shell profile. It must be an absolute path that points to this directory.

AVALON_VERSION=0.0.1;

RED="\033[0;31m";
GREEN="\033[0;32m";
BLUE="\033[0;34m";
END_COLOR="\033[0m";

# Enums
LIBRARY_ARTIFACT_TYPE="library";
GITHUB_CI_CD="github-ci-cd";
NO_CI_CD="no-ci-cd";
AWS_CI_CD="aws-ci-cd";
AWS_NPM_AUTH_TOKEN_SECRET_NAME="AVALON_NPM_AUTH_TOKEN";

# License
CURRENT_YEAR=$(date +"%Y");
AUTHOR_NAME=$(whoami);

function logBlankLine() {
  echo "";
}

function log() {
  message=${1};

  # 💡 Note: "The '-n' flag is usted to keep the white spaces".
  echo -n -e "${message}\n";
}

function avalog() {
  message=${1};

  echo -e "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${message}";
}

function logCommandUsage() {
  usageSyntax=${1};

  logBlankLine;
  log "Usage: ${usageSyntax}";
  logBlankLine;
}

function logCommandDescription() {
  emoji=${1};
  description=${2};

  log "${1}⠀⠀${2}";
  logBlankLine;
}

function logOptionsTitle() {
  log "🏳⠀⠀Options:";
};

function logCommandsTitle() {
  log "📚⠀⠀Commands:";
}

function logCommandFooter() {
  usageSyntax=${1};

  log "Run '${usageSyntax}' for more information on a command.";
}

function handleHelpCommand() {
  logCommandUsage "avalon help COMMAND";
  logCommandDescription "⚔️" "A TypeScript application/library generator with opinionated defaults.";
  logCommandsTitle;
  log "    help          Display this help message.";
  log "    install       Install your project dependencies.";
  log "    develop       Spin up a development environment.";
  log "    test          Execute the test runner.";
  log "    watch-tests   Execute the test runner and watch for changes.";
  log "    format        Format your source code.";
  log "    build         Compile your source code.";
  log "    release       Release your software to the world.";
  log "    new           Create a new Avalon artifact.";
  log "    open          Browse your resources."
  log "    destroy       Remove an avalon project form your machine.";
  logBlankLine;
  logCommandFooter "avalon COMMAND help";

  exit 0;
}

function handleInstallCommand() {
  if [[ $# == 1 ]]
  then
    bash ./scripts/install.sh;
  else
    command=${2};

    case ${command} in
      help)
        logCommandUsage "avalon install";
        logCommandDescription "🛠" "Install your project dependencies.";
        logCommandsTitle;
        log "    help      Display this help message.";
        logBlankLine;

        exit 0;;
      *) handleUnknownCommand;;
    esac
  fi
}

function handleDevelopCommand() {
  if [[ $# == 1 ]]
  then
    bash ./scripts/start-development.sh;
  else
    command=${2};

    case ${command} in
      help)
        logCommandUsage "avalon develop";
        logCommandDescription "🔥" "Spin up a development environment.";
        logCommandsTitle;
        log "    help      Display this help message.";
        logBlankLine;

      exit 0;;
      *) handleUnknownCommand;;
    esac
  fi
}

function handleTestCommand() {
    bash ./scripts/test.sh ${1};
}

function handleWatchTestsCommand() {
    if [[ $# == 1 ]]
    then
        bash ./scripts/watch-tests.sh;
    else
        command=${2};

        case ${command} in
            help) handleTestCommand "help";;
            *) handleUnknownCommand;;
        esac
    fi
}

function handleFormatCommand() {
  if [[ $# == 1 ]]
  then
    bash ./scripts/format.sh;
  else
    command=${2};

    case ${command} in
      help)
        logCommandUsage "avalon format";
        logCommandDescription "💅" "Format your source code.";
        logCommandsTitle;
        log "    help      Display this help message.";
        logBlankLine;

        exit 0;;
      *) handleUnknownCommand;;
    esac
  fi
}

function handleBuildCommand() {
  if [[ $# == 1 ]]
  then
    bash ./scripts/build.sh;
  else
    command=${2};

    case ${command} in
      help)
        logCommandUsage "avalon build";
        logCommandDescription "🧙‍♂️ Compile your source code.";
        logCommandsTitle;
        log "    help      Display this help message.";
        logBlankLine;

        exit 0;;
      *) handleUnknownCommand;;
    esac
  fi
}

function handleReleaseCommand() {
  if [ ! -f ".avaloncli.json" ]
  then
    avalog "${RED}Your artifact is missing its .avaloncli.json configuration file.${END_COLOR}";

    exit 1;
  fi
  
  cicd=$(jq -r ".cicd" .avaloncli.json);

  if [[ ${cicd} == "barebones" ]]
  then
    if [[ $# == 1 ]]
    then
      bash ./scripts/release.sh;
    else
      command=${2};

      case ${command} in
        help)
          logCommandUsage "avalon release";
          logCommandDescription "📦" "Release your software to the world.";
          logCommandsTitle;
          log "    help      Display this help message.";
          logBlankLine;

          exit 0;;
        *) handleUnknownCommand;;
      esac
    fi
  else
    avalog "${RED}Command not supported for this type of artifact. The${END_COLOR} ${BLUE}'avalon release'${END_COLOR} ${RED}command is only available for Avalon barebones libraries.${END_COLOR}";

    exit 2;
  fi
}

function assertArtifactType() {
  artifactType=${1};

  if [[ ${artifactType} != "library" && ${artifactType} != "application" ]]
  then
    avalog "${RED}An unsupported artifact type '${artifactType}' was provided. Avalon only supported${END_COLOR} ${GREEN}'library'${END_COLOR} ${RED}or${END_COLOR} ${GREEN}'app'${END_COLOR} ${RED}as artifact types.${END_COLOR}";

    exit 1;
  fi
}

function assertArtifactName() {
  artifactName=${1};

  if [[ -z ${artifactName} ]]
  then
    avalog "${RED}A name for the library is required.${END_COLOR}";

    exit 1;
  fi
}

function rollback() {
  artifactName=${1};
  imageName="${artifactName}-image";
  containerName="${artifactName}-container";
  sourceVolumeName="${artifactName}-source";

  gh repo delete ${artifactName};
  docker container rm "${containerName}" &> /dev/null;
  docker volume rm "${sourceVolumeName}" &> /dev/null;
  docker image rm "${imageName}" &> /dev/null;
  aws cloudformation delete-stack --stack-name=${artifactName};
  rm -rf ${artifactName};
}

function createLibraryWithNoCiCd() {
  DOCKER_FILE_NAME="createLibraryWithNoCiCd.Dockerfile";

  # Parameters.
  artifactName=${1};
  repositoryUrl=${2};

  # Docker - general.
  imageName="${artifactName}-image";
  dockerfilePath="${AVALON_PATH}/docker/${DOCKER_FILE_NAME}";
  containerName="${artifactName}-container";

  # Docker - Node modules volume.
  nodeModulesVolumeName="${artifactName}-node_modules";
  nodeModulesContainerPath="/node_modules";

  # Docker - Source Code.
  sourceVolumeName="${artifactName}-source";
  sourceCodeContainerPath="/avalon-project";

  avalog "${GREEN}Bootstrapping a new TypeScript library...${END_COLOR}";

  # Pre-execution cleanup
  docker container rm ${containerName} &> /dev/null;
  docker volume rm ${sourceVolumeName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  # Create an image to run a "create library" command.
  docker image build \
    --file ${dockerfilePath} \
    --tag ${imageName} \
    ${AVALON_PATH} || \
    {
        avalog "${RED}Bootstrap Error. Failed while creating an image to run a 'create library' command.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Run the "create library" command container.
  docker container run \
    --interactive \
    --tty \
    -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
    -v ${sourceVolumeName}:${sourceCodeContainerPath} \
    --name ${containerName} \
    ${imageName} ${artifactName} ${CURRENT_YEAR} ${AUTHOR_NAME} \
    || {
        avalog "${RED}Bootstrap Error. Failed while running a 'create library' container command.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Copy the contents of the source code volume into a new `library` directory.
  docker cp ${containerName}:${sourceCodeContainerPath} "./${artifactName}" || \
    {
      avalog "${RED}Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.${END_COLOR}";
      rollback ${artifactName};

      exit 1;
    };

  avalog "${GREEN}Setting up version control...${END_COLOR}";

  # Setup version control.
  cd ${artifactName};
  git init;
  git add --all;
  git commit -m "Initial commit from Avalon v${AVALON_VERSION}";
  git remote add origin ${repositoryUrl};
  git push -u origin main;
  git checkout -b dev;
  git push -u origin dev;

  avalog "${GREEN}Cleaning up...${END_COLOR}";

  # Post-execution cleanup.
  docker volume rm ${sourceVolumeName} &> /dev/null;
  docker container rm ${containerName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  avalog "${GREEN}Success!${END_COLOR} Bootstrapped ${BLUE}${artifactName}${END_COLOR} at ${BLUE}\"$(pwd)/${artifactName}\"${END_COLOR}.";
  logBlankLine;
  log "   ℹ️  Inside that directory, you can run several commands from the ${BLUE}scripts${END_COLOR} directory:";
  logBlankLine;
  log "        ${BLUE}install${END_COLOR}";
  log "        Installs the library dependencies (AKA your node_modules).";
  logBlankLine;
  log "        ${BLUE}start-development${END_COLOR}";
  log "        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript) and re-compiles on changes.";
  logBlankLine;
  log "        ${BLUE}test${END_COLOR}";
  log "        Starts the 🃏 Jest (https://jestjs.io) test runner.";
  logBlankLine;
  log "        ${BLUE}watch-tests${END_COLOR}";
  log "        Starts the 🃏 Jest (https://jestjs.io) test runner and watches for changes.";
  logBlankLine;
  log "        ${BLUE}format${END_COLOR}";
  log "        Formats your source code using 💅 Prettier (https://prettier.io).";
  logBlankLine;
  log "        ${BLUE}build${END_COLOR}";
  log "        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript).";
  logBlankLine;
  log "        ${BLUE}release${END_COLOR}";
  log "        Prompts your 📦 npm (https://www.npmjs.com) credentials to publish your package.";
  logBlankLine;
  log "   🚏 Additionally, a new set of resources was created:";
  logBlankLine;
  log "        🐙 Your artifact's GitHub repository is: ${repositoryUrl}.";
  logBlankLine;
  log "   💡 We suggest that you start by typing:";
  log "        ${BLUE}cd${END_COLOR} ${artifactName}";
  log "        ${BLUE}bash${END_COLOR} scripts/start-development.sh";
  logBlankLine;
  log "   🍻 Happy hacking!";
  logBlankLine;
}

function createLibraryWithGitHubCiCd() {
  DOCKER_FILE_NAME="createLibraryWithGitHubCiCd.Dockerfile";

  # Parameters.
  artifactName=${1};
  repositoryUrl=${2};

  # Docker - general.
  imageName="${artifactName}-image";
  dockerfilePath="${AVALON_PATH}/docker/${DOCKER_FILE_NAME}";
  containerName="${artifactName}-container";

  # Docker - Node modules volume.
  nodeModulesVolumeName="${artifactName}-node_modules";
  nodeModulesContainerPath="/node_modules";

  # Docker - Source Code.
  sourceVolumeName="${artifactName}-source";
  sourceCodeContainerPath="/avalon-project";

  avalog "${GREEN}Bootstrapping a new TypeScript library with a GitHub Actions CI/CD pipeline...${END_COLOR}";

  # Pre-execution cleanup
  docker container rm ${containerName} &> /dev/null;
  docker volume rm ${sourceVolumeName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  # Create an image to run a "create library" command.
  docker image build \
    --file ${dockerfilePath} \
    --tag ${imageName} \
    ${AVALON_PATH} || \
    {
        avalog "${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Run the "create library" command container.
  docker container run \
    --interactive \
    --tty \
    -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
    -v ${sourceVolumeName}:${sourceCodeContainerPath} \
    --name ${containerName} \
    ${imageName} ${artifactName} ${CURRENT_YEAR} ${AUTHOR_NAME} \
    || {
        avalog "${RED} Bootstrap Error. Failed while running a 'create library' container command.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Copy the contents of the source code volume into a new `library` directory.
  docker cp ${containerName}:${sourceCodeContainerPath} "./${artifactName}" || \
    {
        avalog "${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.${END_COLOR}";
        rollback ${artifactName};
  
        exit 1;
    };

  avalog "${GREEN}Setting up version control...${END_COLOR}";

  # Setup version control.
  cd ${artifactName};
  git init;
  git add --all;
  git commit -m "Initial commit from Avalon v${AVALON_VERSION}";
  git remote add origin ${repositoryUrl};
  git push -u origin main;
  git checkout -b dev;
  git push -u origin dev;
  cd ..;

  avalog "${GREEN}Cleaning up...${END_COLOR}";

  # Post-execution cleanup.
  docker volume rm ${sourceVolumeName} &> /dev/null;
  docker container rm ${containerName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  avalog "${GREEN}Success!${END_COLOR} Bootstrapped ${BLUE}${artifactName}${END_COLOR} at ${BLUE}\"$(pwd)/${artifactName}\"${END_COLOR}.";
  logBlankLine;
  log "   ℹ️  Inside that directory, you can run several commands from the ${BLUE}scripts${END_COLOR} directory:";
  logBlankLine;
  log "        ${BLUE}install${END_COLOR}";
  log "        Installs the library dependencies (AKA your node_modules).";
  logBlankLine;
  log "        ${BLUE}start-development${END_COLOR}";
  log "        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript) and re-compiles on changes.";
  logBlankLine;
  log "        ${BLUE}test${END_COLOR}";
  log "        Starts the 🃏 Jest (https://jestjs.io) test runner.";
  logBlankLine;
  log "        ${BLUE}watch-tests${END_COLOR}";
  log "        Starts the 🃏 Jest (https://jestjs.io) test runner and watches for changes.";
  logBlankLine;
  log "        ${BLUE}format${END_COLOR}";
  log "        Formats your source code using 💅 Prettier (https://prettier.io).";
  logBlankLine;
  log "        ${BLUE}build${END_COLOR}";
  log "        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript).";
  logBlankLine;
  log "   🚏 Additionally, a new set of resources was created:";
  logBlankLine;
  log "        🐙 Your artifact's GitHub repository is: ${repositoryUrl}.";
  logBlankLine;
  log "   💡 We suggest that you start by typing:";
  log "        ${BLUE}cd${END_COLOR} ${artifactName}";
  log "        ${BLUE}bash${END_COLOR} scripts/start-development.sh";
  logBlankLine;
  log "   🍻 Happy hacking!";
  logBlankLine;
}

function createLibraryWithAwsCiCd() {
  DOCKER_FILE_NAME="createLibraryWithAwsCiCd.Dockerfile";

  # Parameters.
  artifactName=${1};
  repositoryUrl=${2};

  # Docker - general.
  imageName="${artifactName}-image";
  dockerfilePath="${AVALON_PATH}/docker/${DOCKER_FILE_NAME}";
  containerName="${artifactName}-container";

  # Docker - Node modules volume.
  nodeModulesVolumeName="${artifactName}-node_modules";
  nodeModulesContainerPath="/node_modules";

  # Docker - Source Code.
  sourceVolumeName="${artifactName}-source";
  sourceCodeContainerPath="/avalon-project";

  avalog "${GREEN}Bootstrapping a new TypeScript library with an AWS CI/CD pipeline...${END_COLOR}";

  # Pre-execution cleanup.
  docker container rm ${containerName} &> /dev/null;
  docker volume rm ${sourceVolumeName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  # Retrieve the ARN of your npm authorization token residing in AWS Secrets Manager.
  awsNpmAuthTokenSecretArn=$(aws secretsmanager get-secret-value --secret-id=${AWS_NPM_AUTH_TOKEN_SECRET_NAME} --query="ARN" --output text) || \
    {
        avalog "${RED} Bootstrap Error. Failed to retrieve the ARN of your npm authorization token. Please make sure you have a secret with the name \"${AWS_NPM_AUTH_TOKEN_SECRET_NAME}\" stored in your AWS Secrets Manager.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Create an image to run a "create library" command.
  docker image build \
    --file ${dockerfilePath} \
    --tag ${imageName} \
    ${AVALON_PATH} || \
    {
        avalog "${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Run the "create library" command container.
  docker container run \
    --interactive \
    --tty \
    -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
    -v ${sourceVolumeName}:${sourceCodeContainerPath} \
    --name ${containerName} \
    ${imageName} ${artifactName} ${CURRENT_YEAR} ${AUTHOR_NAME} ${awsNpmAuthTokenSecretArn} \
    || {
        avalog "${RED} Bootstrap Error. Failed while running a 'create library' container command.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  # Copy the contents of the source code volume into a new `library` directory.
  docker cp ${containerName}:${sourceCodeContainerPath} "./${artifactName}" || \
    {
        avalog "${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.${END_COLOR}";
        rollback ${artifactName};

        exit 1;
    };

  avalog "${GREEN}Setting up version control...${END_COLOR}";

  # Setup version control.
  cd ${artifactName};
  git init;
  git add --all;
  git commit -m "Initial commit from Avalon v${AVALON_VERSION}";
  git remote add origin ${repositoryUrl};
  git push -u origin main;
  git checkout -b dev;
  git push -u origin dev;

  avalog "${GREEN}Creating AWS CI/CD infrastructure...${END_COLOR}";

  # Create CI/CD infrastructure.
  aws cloudformation deploy \
    --template-file ./aws/ci-cd.template.json \
    --stack-name ${artifactName} \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides GitHubRepositoryUrl=${repositoryUrl} NpmAuthTokenSecretArn=${awsNpmAuthTokenSecretArn} || \
    {
        avalog "${RED} Bootstrap Error. Failed while CI/CD pipeline in AWS.${END_COLOR}";
        cd ..;
        rollback ${artifactName};

        exit 1;
    };

  cd ..;

  avalog "${GREEN}Cleaning up...${END_COLOR}";

  # Post-execution cleanup.
  docker volume rm ${sourceVolumeName} &> /dev/null;
  docker container rm ${containerName} &> /dev/null;
  docker image rm ${imageName} &> /dev/null;

  awsRegion=$(aws configure get region);
  awsAccountId=$(aws sts get-caller-identity --query "Account" --output text);

  avalog "${GREEN}Success!${END_COLOR} Bootstrapped ${BLUE}${artifactName}${END_COLOR} at \"${BLUE}$(pwd)/${artifactName}\"${END_COLOR}.";
  logBlankLine;
  log "   ℹ️  Inside that directory, you can run several commands from the ${BLUE}scripts${END_COLOR} directory:";
  logBlankLine;
  log "        ${BLUE}install${END_COLOR}";
  log "        Installs the library dependencies (AKA your node_modules).";
  logBlankLine;
  log "        ${BLUE}start-development${END_COLOR}";
  log "        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript) and re-compiles on changes.";
  logBlankLine;
  log "        ${BLUE}test${END_COLOR}";
  log "        Starts the 🃏 Jest (https://jestjs.io) test runner.";
  logBlankLine;
  log "        ${BLUE}watch-tests${END_COLOR}";
  log "        Starts the 🃏 Jest (https://jestjs.io) test runner and watches for changes.";
  logBlankLine;
  log "        ${BLUE}format${END_COLOR}";
  log "        Formats your source code using 💅 Prettier (https://prettier.io).";
  logBlankLine;
  log "        ${BLUE}build${END_COLOR}";
  log "        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript).";
  logBlankLine;
  log "   🚏 Additionally, a new set of resources was created:";
  logBlankLine;
  log "        🐙 Your artifact's GitHub repository is: ${repositoryUrl}.";
  logBlankLine;
  log "        ☁️  Your CI CodeBuild project is: https://${awsRegion}.console.aws.amazon.com/codesuite/codebuild/${awsAccountId}/projects/${artifactName}-DevelopmentBuild/history?region=${awsRegion}.";
  logBlankLine;
  log "        ☁️  Your CD CodeBuild project is: https://${awsRegion}.console.aws.amazon.com/codesuite/codebuild/${awsAccountId}/projects/${artifactName}-ProductionBuild/history?region=${awsRegion}.";
  logBlankLine;
  log "   💡 We suggest that you start by typing:";
  log "        ${BLUE}cd${END_COLOR} ${artifactName}";
  log "        ${BLUE}bash${END_COLOR} scripts/start-development.sh";
  logBlankLine;
  log "   🍻 Happy hacking!";
  logBlankLine;
}

function handleNewCommand() {
  START_TIME=$(date +%s);

  artifactName=${2};

  # Defaults.
  artifactType=${LIBRARY_ARTIFACT_TYPE};
  cicd=${GITHUB_CI_CD};

  for option in "$@"
  do
    case ${option} in
      help)
        logCommandUsage "avalon new create ARTIFACT_NAME [OPTIONS] [COMMAND]";
        logCommandDescription "🏗" "Create software artifacts.";
        logOptionsTitle;
        log "    --artifact=string      Sets the software artifact type (\"library\"|\"application\").";
        log "    --ci-cd=string         Sets the continous integration configuration (\"barebones\"|\"github-actions\"|\"aws\").";
        logBlankLine;
        logCommandsTitle;
        log "    help      Display this help message.";
        logBlankLine;

        exit 0;;
      "--artifact=library") artifactType=${LIBRARY_ARTIFACT_TYPE};;
      "--ci-cd=barebones") cicd=${NO_CI_CD};;
      "--ci-cd=github-actions") cicd=${GITHUB_CI_CD};;
      "--ci-cd=aws") cicd=${AWS_CI_CD};;
      "--"*)
        log "${option} is not an Avalon command.";
        log "See 'avalon new help'";

        exit 1;;
    esac
  done

  assertArtifactName ${artifactName};
  assertArtifactType ${artifactType};

  gh repo create ${artifactName} --private || \
    {
      avalog "${RED} Bootstrap Error. Failed while creating a attempting to create GitHub Repository. Make sure GitHub CLI is properly configured with your credentials.${END_COLOR}";
      rollback ${artifactName};

      exit 1;
    };

  avalog "${GREEN}Creating new GitHub repository for ${artifactName}...${END_COLOR}";

  repositoryUrl=$(gh repo view ${artifactName} --json "url"  --jq ".url");

  if [[ ${artifactType} == ${LIBRARY_ARTIFACT_TYPE} ]]
  then
    if [[ ${cicd} == ${NO_CI_CD} ]]
    then
      createLibraryWithNoCiCd ${artifactName} ${repositoryUrl};
    elif [[ ${cicd} == ${GITHUB_CI_CD} ]]
    then
      createLibraryWithGitHubCiCd ${artifactName} ${repositoryUrl};
    elif [[ ${cicd} == ${AWS_CI_CD} ]]
    then
      createLibraryWithAwsCiCd ${artifactName} ${repositoryUrl};
    fi
  fi

  END_TIME=$(date +%s);
  timeInSeconds=$((${END_TIME}-${START_TIME}));
  logBlankLine;
  log "   Time: ${BLUE}~${timeInSeconds}s${END_COLOR}.";
  logBlankLine;

  exit 0;
}

function handleOpenCommand() {
  if [[ $# == 1 ]]
  then
    logCommandUsage "avalon open COMMAND";
    logCommandDescription "🌐" "Browse your resources.";
    logCommandsTitle;
    log "    repo      Navigate to your artifact's GitHub repository in your browser.";
    log "    ci        Navigate to your artifact's CodeBuild CI Project in your browser.";
    log "    cd        Navigate to your artifact's CodeBuild CD Project in your browser.";
    log "    help      Display this help message.";
    logBlankLine;

    exit 0;
  else
    command=${2};

    case ${command} in
      help)
        logCommandUsage "avalon open COMMAND";
        logCommandDescription "🌐" "Browse your resources.";
        logCommandsTitle;
        log "    repo      Navigate to your artifact's GitHub repository in your browser.";
        log "    ci        Navigate to your artifact's CodeBuild CI Project in your browser.";
        log "    cd        Navigate to your artifact's CodeBuild CD Project in your browser.";
        log "    help      Display this help message.";
        logBlankLine;

        exit 0;;
      repo)
        if [ ! -f ".avaloncli.json" ]
        then
          avalog "${RED}Your artifact is missing its .avaloncli.json configuration file.${END_COLOR}";

          exit 1;
        fi
        
        gh repo view --web &> /dev/null;;
      ci)
        if [ ! -f ".avaloncli.json" ]
        then
          avalog "${RED}Your artifact is missing its .avaloncli.json configuration file.${END_COLOR}";

          exit 1;
        fi

        artifactName=$(jq -r ".artifactName" .avaloncli.json);
        cicd=$(jq -r ".cicd" .avaloncli.json);

        if [[ ${cicd} == "aws" ]]
        then
          awsRegion=$(aws configure get region) || \
          {
              avalog "${RED}Failed to obtain the AWS region configured for the AWS CLI.${END_COLOR}";

              exit 1;
          };

          awsAccountId=$(aws sts get-caller-identity --query "Account" --output text) || \
          {
              avalog "${RED}Failed to obtain the AWS account id configured for the AWS CLI.${END_COLOR}";

              exit 1;
          };

          open "https://${awsRegion}.console.aws.amazon.com/codesuite/codebuild/${awsAccountId}/projects/${artifactName}-DevelopmentBuild/history?region=${awsRegion}";
        else
          avalog "${RED}Command not supported for artifacts using this CI/CD pipeline configuration. The${END_COLOR} ${BLUE}'avalon open ci'${END_COLOR} ${RED}command is only available for artifacts with AWS with a CI/CD pipeline.${END_COLOR}";

          exit 2;
        fi
        ;;
      cd)
        if [ ! -f ".avaloncli.json" ]
        then
          avalog "${RED}Your artifact is missing its .avaloncli.json configuration file.${END_COLOR}";

          exit 1;
        fi

        artifactName=$(jq -r ".artifactName" .avaloncli.json);
        cicd=$(jq -r ".cicd" .avaloncli.json);

        if [[ ${cicd} == "aws" ]]
        then
          awsRegion=$(aws configure get region) || \
          {
              avalog "${RED}Failed to obtain the AWS region configured for the AWS CLI.${END_COLOR}";

              exit 1;
          };

          awsAccountId=$(aws sts get-caller-identity --query "Account" --output text) || \
          {
              avalog "${RED}Failed to obtain the AWS account id configured for the AWS CLI.${END_COLOR}";

              exit 1;
          };

          open "https://${awsRegion}.console.aws.amazon.com/codesuite/codebuild/${awsAccountId}/projects/${artifactName}-ProductionBuild/history?region=${awsRegion}";
        else
          avalog "${RED}Command not supported for artifacts using this CI/CD pipeline configuration. The${END_COLOR} ${BLUE}'avalon open cd'${END_COLOR} ${RED}command is only available for artifacts with AWS with a CI/CD pipeline.${END_COLOR}";

          exit 2;
        fi
      ;;
      *) handleUnknownCommand;;
    esac
  fi
}

function handleDestroyCommand() {
  if [[ $# == 1 ]]
  then
    avalog "${RED}The name of the artifact is required.${END_COLOR}";

    exit 1;
  else
    command=${2};

    case ${command} in
      help)
        logCommandUsage "avalon destroy ARTIFACT_NAME [COMMAND]";
        logCommandDescription "🗑  Remove an avalon project form your machine thoroughly.";
        logCommandsTitle;
        log "    help      Display this help message.";
        logBlankLine;

        exit 0;;
      *)
        artifactName=${2};

        imageName="${artifactName}-image";
        buildImageName="${artifactName}-build-image";
        ciImageName="${artifactName}-ci-image";
        formatImageName="${artifactName}-format-image";
        installationImageName="${artifactName}-installation-image";
        releaseImageName="${artifactName}-release-image";
        startDevelopmentImageName="${artifactName}-development-image";
        testImageName="${artifactName}-test-image";

        containerName="${artifactName}-container";
        buildContainerName="${artifactName}-build-container";
        ciContainerName="${artifactName}-ci-container";
        formatImageContainer="${artifactName}-format-container";
        instalationContainerName="${artifactName}-installation-container";
        releaseContainerName="${artifactName}-release-container";
        startDevelopmentContainerName="${artifactName}-development-container";
        testContainerName="${artifactName}-test-container";

        sourceVolumeName="${artifactName}-source";
        nodeModulesVolumeName="${artifactName}-node_modules";

        docker container rm ${containerName} &> /dev/null;
        docker container rm ${buildContainerName} &> /dev/null;
        docker container rm ${ciContainerName} &> /dev/null;
        docker container rm ${formatImageContainer} &> /dev/null;
        docker container rm ${instalationContainerName} &> /dev/null;
        docker container rm ${releaseContainerName} &> /dev/null;
        docker container rm ${startDevelopmentContainerName} &> /dev/null;
        docker container rm ${testContainerName} &> /dev/null;

        docker volume rm ${sourceVolumeName} &> /dev/null;
        docker volume rm ${nodeModulesVolumeName} &> /dev/null;

        docker image rm ${imageName} &> /dev/null;
        docker image rm ${buildImageName} &> /dev/null;
        docker image rm ${ciImageName} &> /dev/null;
        docker image rm ${formatImageName} &> /dev/null;
        docker image rm ${installationImageName} &> /dev/null;
        docker image rm ${releaseImageName} &> /dev/null;
        docker image rm ${startDevelopmentImageName} &> /dev/null;
        docker image rm ${testImageName} &> /dev/null;

        aws cloudformation delete-stack --stack-name=${artifactName};

        gh repo delete ${artifactName};

        rm -rf ${artifactName};
        exit 0;;
    esac
  fi
}

function handleUnknownCommand() {
  avalog "${RED}Command not supported. Try using${END_COLOR} ${BLUE}'avalon help'${END_COLOR} ${RED}command.${END_COLOR}";

  exit 2;
}

function bootstrap() {
  if [[ $# == 0 ]]
  then
    handleHelpCommand;
  fi

  command=${1};

  case ${command} in
    help) handleHelpCommand $@;;
    install) handleInstallCommand $@;;
    develop) handleDevelopCommand $@;;
    test) handleTestCommand ${2};;
    watch-tests) handleWatchTestsCommand $@;;
    format) handleFormatCommand $@;;
    build) handleBuildCommand $@;;
    release) handleReleaseCommand $@;;
    new) handleNewCommand $@;;
    open) handleOpenCommand $@;;
    destroy) handleDestroyCommand $@;;
    *) handleUnknownCommand;;
  esac
}

bootstrap $@;
