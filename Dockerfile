FROM amd64/alpine:3.20

ENV APP_UID=1654 \
    # 运行时端口
    DOTNET_PORTS=20000 \
    # Development 开发版 Staging 暂存版 Production 发布版
    ASPNETCORE_ENVIRONMENT=Production \
    DOTNET_RUNNING_IN_CONTAINER=true \
    ALPINE_VERSION=3.20 \
    DOTNET_VERSION=9.0.0

COPY *.tar.gz /root/

RUN set -x \
	&& apk add --upgrade --no-cache 'su-exec>=0.2' ca-certificates-bundle tzdata icu-dev libgcc libssl3 libstdc++ zlib \
	&& rm -f /etc/localtime \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && addgroup --gid=$APP_UID app \
    && adduser --uid=$APP_UID --ingroup=app --disabled-password app \
    && mkdir -p /usr/share/dotnet \
    && cd /root/ \
    && tar -oxzf dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz -C /usr/share/dotnet \
    && rm dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

WORKDIR /game/App
EXPOSE $DOTNET_PORTS