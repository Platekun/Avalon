function bootstrap() {
  PROJECT_NAME=${1};
  YEAR=${2};
  AUTHOR_NAME=${3};

  cd "./avalon-project";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" ".avaloncli.json";

  cd "./docker";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "install.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "start-development.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "build.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "test.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "watch-tests.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "format.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "release.Dockerfile";

   cd "../scripts";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "install.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "start-development.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "build.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "test.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "watch-tests.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "format.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "release.sh";

  cd "../library";
  sed -i "s/{{year}}/${YEAR}/" "LICENSE";
  sed -i "s/{{authorName}}/${AUTHOR_NAME}/" "LICENSE";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "package.json";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "package-lock.json";
}

bootstrap $@;
