#
# docker build -t iamteacher/artelectronics.ru:webapp.amd64 -f Dockerfile ../ --build-arg PLATFORM=amd
# docker build -t iamteacher/artelectronics.ru:webapp.arm64 -f Dockerfile ../ --build-arg PLATFORM=arm

ARG PLATFORM
FROM iamteacher/eastflower.ru:webapp.${PLATFORM}64

SHELL ["/bin/bash", "--login", "-c"]
WORKDIR /home

RUN ~/.rbenv/shims/gem update --system '3.0.9'

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN /root/.rbenv/shims/bundle
