FROM debian:jessie

RUN \
  useradd -r -s /bin/false varnishd

# Install Varnish source build dependencies.
RUN \
  apt-get update && apt-get install -y --no-install-recommends \
    automake \
    build-essential \
    ca-certificates \
    git \
    curl \
    libvarnishapi-dev \
    libedit-dev \
    libjemalloc-dev \
    libncurses-dev \
    libpcre3-dev \
    libtool \
    pkg-config \
    python-docutils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Varnish from source, so that Varnish modules can be compiled and installed.
ENV VARNISH_VERSION=4.1.4
ENV VARNISH_SHA256SUM=44fdeb66fb27af9c18fde6123ef7b0038d6d263c7999a02a780ce4ea1a3965fc
RUN \
  apt-get update && \
  mkdir -p /usr/local/src && \
  cd /usr/local/src && \
  curl -sfLO https://repo.varnish-cache.org/source/varnish-$VARNISH_VERSION.tar.gz && \
  echo "${VARNISH_SHA256SUM} varnish-$VARNISH_VERSION.tar.gz" | sha256sum -c - && \
  tar -xzf varnish-$VARNISH_VERSION.tar.gz && \
  cd varnish-$VARNISH_VERSION && \
  ./autogen.sh && \
  ./configure && \
  make install && \
  rm ../varnish-$VARNISH_VERSION.tar.gz

RUN \
  git clone https://github.com/varnish/varnish-modules.git && \
  cd varnish-modules && \
  ./bootstrap && \
  ./configure && \
  make && \
  make install

RUN git clone http://git.gnu.org.ua/cgit/vmod-basicauth.git && cd vmod-basicauth \
    && git clone http://git.gnu.org.ua/repo/acvmod.git && ./bootstrap \
    && ./configure VARNISHSRC=/usr/local/src/varnish-$VARNISH_VERSION VMODDIR=/usr/lib/varnish/vmods/ && make && make install && make check

RUN bash -c set -eo pipefail

COPY default.vcl /etc/varnish/
WORKDIR /etc/varnish

EXPOSE 6081 6082

COPY docker-entrypoint.sh /usr/local/bin/
CMD "docker-entrypoint.sh"
