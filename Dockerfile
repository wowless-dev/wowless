FROM debian
RUN apt-get update \
  && \
    apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
  && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && \
    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
    http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
  && \
    apt-get update \
  && \
    apt-get -y install --no-install-recommends \
    build-essential \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    google-cloud-sdk \
    libpcre3-dev \
    libssl-dev \
    lua5.1 \
    make \
    perl \
    python3 \
    unzip \
    wget \
    zlib1g-dev \
  && \
    apt-get clean
RUN wget https://openresty.org/download/openresty-1.19.9.1.tar.gz \
  && \
    tar zxvf openresty-1.19.9.1.tar.gz \
  && \
    cd openresty-1.19.9.1 \
  && \
    ./configure -j2 \
  && \
    make -j2 \
  && \
    make install \
  && \
    cd .. \
  && \
    rm -rf openresty-1.19.9.1.tar.gz openresty-1.19.9.1
WORKDIR /wowless-dev
COPY nginx.conf query.sh wowless.lua ./
COPY wowless/ wowless/
CMD service docker start \
  && \
    sleep 1 \
  && \
    mkdir -p /root/.cache/luadbd \
  && \
    /usr/local/openresty/nginx/sbin/nginx -p . -c nginx.conf
