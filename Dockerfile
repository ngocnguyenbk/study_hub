FROM ruby:3.4.2

RUN apt-get update -y && apt-get install -y apt-transport-https

RUN apt-get update -y && apt-get install -y \
    curl \
    wget \
    gcc g++ make\
    vim \
    zlib1g-dev \
    build-essential \
    libssl-dev \
    git-core \
    cmake \
    libmariadb-dev

ENV LANG=C.UTF-8
RUN gem install bundler

RUN mkdir /study_hub

WORKDIR /study_hub
