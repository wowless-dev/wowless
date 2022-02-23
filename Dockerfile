FROM wowless/base
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
    http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt update && \
    apt -y install libpcre3-dev libssl-dev perl make build-essential curl google-cloud-sdk && \
    apt clean
RUN wget https://openresty.org/download/openresty-1.19.9.1.tar.gz && \
    tar zxvf openresty-1.19.9.1.tar.gz && \
    cd openresty-1.19.9.1 && \
    ./configure -j2 && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -rf openresty-1.19.9.1.tar.gz openresty-1.19.9.1/
WORKDIR /opt/wowless
COPY wowless/ wowless/
RUN mkdir -p /root/.cache/luadbd && \
    cd wowless/tainted-lua && \
    cmake --preset linux && \
    cmake --build --preset linux && \
    cd .. && \
    luarocks build --no-install
COPY nginx.conf query.sh wowless.lua ./
CMD /usr/local/openresty/nginx/sbin/nginx -p . -c nginx.conf
