ARG NODE_VERSION=10
ARG NG_CLI_VERSION=6.1.3

FROM node:$NODE_VERSION

LABEL "authors"="Julian Labuschagne <julian.labuschagne@gmail.com>"
LABEL "description"="Angular Development Environment"

ENV NG_CLI_VERSION=$NG_CLI_VERSION

# Create a non privileged user
#RUN addgroup --gid 1000 $USERGROUP && \
#    adduser --uid 1000 --ingroup $USERGROUP --home /var/$USERNAME --shell /bin/sh --disabled-password --gecos "" $USERNAME

RUN USER=node && \
    GROUP=node && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

RUN yarn global add @angular/cli@$NG_CLI_VERSION && rm -rf $(yarn cache dir) && \
    npm install -g firebase-tools

USER node:node
WORKDIR /home/node

RUN git config --global user.email "julian.labuschagne@gmail.com"
RUN git config --global user.name "julianlab/angular container"

ENTRYPOINT  ["fixuid"]
CMD "/bin/bash"
