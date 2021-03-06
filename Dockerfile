FROM ubuntu:bionic

MAINTAINER Mohammad Mahdi Baghbani Pourvahid <MahdiBaghbani@protonmail.com>

# set frontend to noneinteractive.
ARG DEBIAN_FRONTEND=noninteractive

# change default shell from sh to bash.
SHELL ["/bin/bash", "-l", "-c"]

# update apt database.
RUN apt-get update --assume-yes

# install apt utils to speed up configs.
RUN apt-get install --assume-yes --no-install-recommends apt-utils

# install latest libc6 library.
RUN apt-get install --assume-yes libc6

# set locale.
RUN apt-get install --assume-yes locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# install git.
RUN apt-get install --assume-yes git

# install curl.
RUN apt-get install --assume-yes curl

# install gnupg.
RUN apt-get install --assume-yes gnupg

# disable ipv6 in docker for gpg.
RUN mkdir -p ~/.gnupg
RUN chmod 700 ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN chmod 600 ~/.gnupg/*

# install codeclimate coverage reporter.
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/bin/cc-test-reporter
RUN chmod +x /usr/bin/cc-test-reporter

# add rvm keys.
RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# install ruby version manager (rvm) using curl.
RUN \curl -sSL https://get.rvm.io | bash -s stable

# setup rvm.
RUN echo "source /etc/profile.d/rvm.sh" >> ~/.bash_profile

# install rvm requirements.
RUN rvm requirements

# install ruby versions.
RUN rvm install 2.0
RUN rvm install 2.1
RUN rvm install 2.2
RUN rvm install 2.3
RUN rvm install 2.4
RUN rvm install 2.5
RUN rvm install 2.6

# specify working directory.
ENV TESTBUILD ~/test_and_build
RUN mkdir -p $TESTBUILD
WORKDIR $TESTBUILD

