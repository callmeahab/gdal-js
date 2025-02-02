FROM ubuntu:16.04

RUN apt-get update && apt-get -y install \ 
    build-essential \
    cmake \
    autoconf \
    python2.7 \
    python \
    nodejs \
    default-jre \
    libtool \
    curl \
    git-core \
    zip

WORKDIR /opt
# Unfortunately, this repo has no versioning that I could detect, either via tags or branches
# One option would be to pin to a particular commit, but that would be arbitrary, and it seems
# that the interface provided is relatively stable because this is a core piece of the
# Emscripten ecosystem. Given that, I decided to run the risk of behavior changing over time
# by not pinning.
RUN git clone https://github.com/emscripten-core/emsdk.git

WORKDIR /opt/emsdk

ARG EMSCRIPTEN_V

RUN ./emsdk update-tags && ./emsdk install ${EMSCRIPTEN_V}
RUN ./emsdk activate ${EMSCRIPTEN_V}

RUN git config --global user.name 'Nobody'
RUN git config --global user.email 'nobody@nowhere.nope'

RUN mkdir /opt/gdaljs

WORKDIR /opt
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

WORKDIR /opt/gdaljs

ENTRYPOINT ["/opt/entrypoint.sh"]
