function bootstrap() {
  PROJECT_NAME=${1};
  CODEBUILD_DOCKER_RUNTIME_ROLE_ARN=${2};

  # 💡 https://stackoverflow.com/questions/407523/escape-a-string-for-a-sed-replace-pattern
  ESCAPED_CODEBUILD_DOCKER_RUNTIME_ROLE_ARN=$(printf '%s\n' "${CODEBUILD_DOCKER_RUNTIME_ROLE_ARN}" | sed -e 's/[]\/$*.^[]/\\&/g');

  echo ${PROJECT_NAME};
  echo ${CODEBUILD_DOCKER_RUNTIME_ROLE_ARN};
  echo ${ESCAPED_CODEBUILD_DOCKER_RUNTIME_ROLE_ARN};

  cd "./${PROJECT_NAME}";
  sed -i "s/{{codeBuildDockerRuntimeRoleArn}}/${ESCAPED_CODEBUILD_DOCKER_RUNTIME_ROLE_ARN}/" "aws/buildspec.cd.yml";
}

bootstrap $@;
