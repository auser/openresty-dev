FROM openresty/openresty:1.11.2.1-xenial

ENV PREFIX /usr/local
ENV RESTY_HOME $PREFIX/openresty
ENV PATH $RESTY_HOME/nginx/sbin:$RESTY_HOME/bin:$RESTY_HOME/luajit/bin:$PATH


RUN apt-get update -yq && \
    apt-get install -yq libssl-dev \
        wget gettext git-core

RUN FSWATCH_VERSION=1.9.3 && \
    cd /usr/local/src && \
    wget https://github.com/emcrisostomo/fswatch/releases/download/$FSWATCH_VERSION/fswatch-$FSWATCH_VERSION.tar.gz && \
    tar -xvf fswatch-$FSWATCH_VERSION.tar.gz && \
    rm fswatch-$FSWATCH_VERSION.tar.gz && \
    cd fswatch-$FSWATCH_VERSION && \
    ./configure && make && make install && ldconfig


ENV LUA_PATH "./src/?.lua;./src/?/?.lua;./src/?/init.lua;/usr/local/openresty/lualib/?/?.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/nginx/lualib/?.lua;./?.lua;/usr/local/openresty/lib/?.lua;;"

RUN luarocks install luacrypto && \
    luarocks install lua-resty-session && \
    luarocks install lua-resty-jwt && \
    luarocks install --server=http://rocks.moonscript.org luajwt && \
    mkdir -p /usr/local/openresty/lib/ && \
    git clone https://github.com/pintsized/lua-resty-rack.git /tmp/rack && \
    cp -r /tmp/rack/lib/ /usr/local/openresty/

COPY ./priv/conf $RESTY_HOME/nginx/conf
# Change the NGINX user to www-data, since Ubuntu does not have xfs
RUN sed -i s/xfs/www-data/g $RESTY_HOME/nginx/conf/nginx.conf
COPY ./src $RESTY_HOME/nginx/lualib
COPY ./priv/sites-enabled $RESTY_HOME/nginx/sites-enabled

COPY ./scripts/reload_nginx.sh $PREFIX/bin/reload_nginx.sh
RUN mkdir -p /run && \
    chmod +x $PREFIX/bin/reload_nginx.sh

ENTRYPOINT $PREFIX/bin/reload_nginx.sh