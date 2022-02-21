function bootstrap() {
  PROJECT_NAME=${1};

  cd "./avalon-project";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" ".avaloncli.json";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "aws/buildspec.cd.yml";

  cd "./docker";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "install.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "start-development.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "build.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "format.Dockerfile";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "release.Dockerfile";

  cd "../scripts";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "install.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "start-development.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "build.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "format.sh";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "release.sh";

  cd "../ui";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "package.json";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "package-lock.json";

  cd "./source"
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "./site.webmanifest";
  sed -i "s/{{projectName}}/${PROJECT_NAME}/" "./assets/includes/website-info.html";
}

bootstrap $@;
