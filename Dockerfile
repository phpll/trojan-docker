FROM alpine:3.9

# 安装构建依赖
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        boost-dev \
        openssl-dev \
        mariadb-connector-c-dev \
        git \
    && git clone https://github.com/trojan-gfw/trojan.git \
    && cd trojan \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr . \
    && make install \
    && strip -s /usr/bin/trojan \
    && cd .. \
    && rm -rf trojan \
    && apk del .build-deps \
    && apk add --no-cache --virtual .trojan-rundeps \
        libstdc++ \
        boost-system \
        boost-program_options \
        mariadb-connector-c

# 复制配置文件
COPY trojan-config.json /usr/local/etc/trojan/config.json

# 暴露端口
EXPOSE 443

# 启动Trojan
CMD ["trojan", "/usr/local/etc/trojan/config.json"]
