FROM 9jkh/dotdeb:ubuntu-bionic
MAINTAINER 9JKH Dev<dev@9jkh.co.za>

ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGE_NAME

# resolve package dependencies
ADD debian/control /root/
RUN mk-build-deps --install --tool 'apt-get -y -qq' --remove /root/control && rm -f /root/control

ADD . /usr/src/builddir
WORKDIR /usr/src/builddir

RUN uscan --download-current-version
RUN cd "$(find .. -type d -name ${PACKAGE_NAME}-\*)" && dpkg-buildpackage > /dev/null
