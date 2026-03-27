FROM ghcr.io/giganticplayground/git-sync/alpine:3.23

LABEL "repository"="https://github.com/GiganticPlayground/git-sync"
LABEL "homepage"="https://github.com/GiganticPlayground/git-sync"
LABEL "maintainer"="daniel.morris@giganticplayground.com"
LABEL "org.opencontainers.image.source"="https://github.com/GiganticPlayground/git-sync"

RUN apk add --no-cache git git-lfs openssh-client && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
