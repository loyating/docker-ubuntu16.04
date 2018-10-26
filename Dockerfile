FROM ubuntu:16.04

MAINTAINER loyating <loyating@foxmail.com>

ENV BUILD_TYPE release
ENV LIB_TYPE shared

ADD ./sources.list /etc/apt/
ADD ./ninja-1.8.2.tar.gz /root/
ADD ./meson-0.48.1.tar.gz /root/
ADD ./jsoncpp-1.8.4.tar.gz /root/
ADD ./protobuf-cpp-3.3.0.tar.gz /root/

# install modules
RUN apt-get update && apt-get install -y \
    python3 \
    python3-setuptools \
    re2c \
    gcc \
    g++ \
    autoconf \
    automake \
    libtool \
    make \
    unzip \
    libmysqlclient-dev \
    libcurl4-openssl-dev && \
    ln -s /usr/bin/python3.5 /usr/bin/python && \
    python --version && \

    echo "===>Install ninja-1.8.2..." && \
    cd /root/ninja-1.8.2/ && \
    ./configure.py --bootstrap && \
    cp /root/ninja-1.8.2/ninja /usr/bin/ && \
    echo "===>Install meson-0.48.1..." && \
    cd /root/meson-0.48.1/ && \
    python setup.py install && \
    echo "===>Install jsoncpp-1.8.4..." && \
    cd /root/jsoncpp-1.8.4/ && \
    meson --buildtype ${BUILD_TYPE} --default-library ${LIB_TYPE} . build-${LIB_TYPE} && \
    ninja -v -C build-${LIB_TYPE} && \
    cd build-${LIB_TYPE}/ && \
    meson test --no-rebuild --print-errorlogs && \
    ninja install && \
    echo "===>Install protobuf-cpp-3.3.0..." && \
    cd /root/protobuf-3.3.0/ && \
    ./configure && make && make check && make install && ldconfig && \
    echo "===> Clean up..." && \
    apt-get remove -y --auto-remove make python3 python3-setuptools re2c libtool unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /root/*





