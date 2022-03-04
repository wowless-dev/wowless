FROM debian:testing AS openresty-builder
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        build-essential \
        ca-certificates \
        libpcre3-dev \
        libssl-dev \
        wget \
        zlib1g-dev && \
    apt-get clean
RUN wget https://openresty.org/download/openresty-1.19.9.1.tar.gz && \
    tar zxf openresty-1.19.9.1.tar.gz && \
    cd openresty-1.19.9.1 && \
    ./configure -j2 && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -rf openresty-1.19.9.1.tar.gz openresty-1.19.9.1/

FROM ghcr.io/lua-wow-tools/wowless:latest AS runtime
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        python3 \
        unzip && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
    http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && \
    apt-get -y install --no-install-recommends google-cloud-sdk && \
    apt-get clean
COPY --from=openresty-builder /usr/local/openresty /usr/local/openresty
WORKDIR /opt/wowless
COPY nginx.conf query.sh wowless.lua .
ENTRYPOINT /usr/local/openresty/nginx/sbin/nginx -p . -c nginx.conf
