#
# docker build -t iamteacher/artelectronics.ru:webapp.arm64 -f Dockerfile ../ --build-arg PLATFORM=arm
# docker build -t iamteacher/artelectronics.ru:webapp.amd64 -f Dockerfile ../ --build-arg PLATFORM=amd
#
# docker push iamteacher/artelectronics.ru:webapp.arm64
# docker push iamteacher/artelectronics.ru:webapp.amd64
#
ARG PLATFORM
FROM iamteacher/rails4:2022.${PLATFORM}64

USER lucky

RUN gem update --system '3.0.9'
RUN gem install bundler -v 1.17.3 --verbose --no-document

RUN git config --global --add safe.directory /home/lucky/app
RUN mkdir /home/lucky/app

WORKDIR /home/lucky/app

COPY Gemfile /home/lucky/app/Gemfile
COPY Gemfile.lock /home/lucky/app/Gemfile.lock

RUN bundle
EXPOSE 3000/tcp
