FROM debian:buster-slim

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get -y --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    gnupg \
    locales \
    gdebi \
    wget && \
    apt-get clean

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

# install slack and deps
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        libasound2 \
        libgtk-3-0 \
        libx11-xcb1 \
        libxkbfile1 \
        && \
    wget --quiet https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb && \
    gdebi --non-interactive -o="--no-install-recommends" slack-desktop-3.3.3-amd64.deb && \
    apt-get clean && rm -rvf /var/lib/apt/lists/* slack-desktop-3.3.3-amd64.deb

ARG user=insider
ARG group=insider
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} && useradd -u ${uid} -g ${gid} -m ${user}

USER insider

ENTRYPOINT ["/usr/lib/slack/slack"]
