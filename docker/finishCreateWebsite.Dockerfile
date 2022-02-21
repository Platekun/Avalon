FROM node:16-alpine

RUN apk update

# 💡 https://stackoverflow.com/questions/40944479/docker-how-to-use-bash-with-an-alpine-based-docker-image
RUN apk add bash

COPY ./scripts/finishWebsite.sh ./finishWebsite.sh
RUN chmod +x finishWebsite.sh

# 💡 https://stackoverflow.com/questions/14219092/bash-script-and-bin-bashm-bad-interpreter-no-such-file-or-directory
RUN sed -i -e 's/\r$//' finishWebsite.sh

# 💡 https://stackoverflow.com/questions/37904682/how-do-i-use-docker-environment-variable-in-entrypoint-array
ENTRYPOINT ["/bin/bash", "-c", "exec ./finishWebsite.sh ${@}", "--"];
