FROM ubuntu:xenial-20180228

RUN apt-get update \
&& apt-get install -y wget git build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libzmq3-dev \
&& cd /tmp \
&& git clone --recursive https://github.com/BlockchainTechLLC/3dcoin.git \
&& cd ./3dcoin \
&& wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' \
&& echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c \
&& tar -xzf db-4.8.30.NC.tar.gz \
&& cd ./db-4.8.30.NC/build_unix/ \
&& ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/tmp/3dcoin/db4 \
&& make install \
&& cd ../.. \
&& ./autogen.sh \
&& ./configure LDFLAGS="-L/tmp/3dcoin/db4/lib/" CPPFLAGS="-I/tmp/3dcoin/db4/include/" --without-miniupnpc --without-gui \
&& make \
&& make install \
&& cd ./src \
&& mv 3dcoin-cli /usr/bin/3dcoin-cli \
&& mv 3dcoin-tx /usr/bin/3dcoin-tx \
&& mv 3dcoind /usr/bin/3dcoind \
&& chmod a+x /usr/bin/3dcoin-cli /usr/bin/3dcoin-tx /usr/bin/3dcoind \
&& cd /tmp \
&& rm -rf 3dcoin \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "tail -f /dev/null"]
