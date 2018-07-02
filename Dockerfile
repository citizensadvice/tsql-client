FROM debian:stretch-slim

ENV TSQL_VERSION 1.00.86
ENV FREETDS_VERSION=1.00.92
ENV FREETDS_MD5=71316f7e5a4d1a072c7320bd2f1d4224

# Install MS Sql Server client tools (used to source e.g. bcp)
RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl apt-transport-https gnupg ca-certificates libterm-readline-gnu-perl; \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; \
    curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/msprod.list ; \
    apt-get update; \
    ACCEPT_EULA=y apt-get install -y mssql-tools; \
    apt-get install -y --no-install-recommends build-essential make gcc; \
    FREETDS_DIRNAME=freetds-$FREETDS_VERSION; \
    FREETDS_FILENAME=$FREETDS_DIRNAME.tar.gz; \
    FREETDS_URL=http://www.freetds.org/files/stable/$FREETDS_FILENAME; \
    FREETDS_BUILD_DIR=/freetds_build; \
    mkdir $FREETDS_BUILD_DIR; \
    cd $FREETDS_BUILD_DIR; \
    curl -O $FREETDS_URL; \
    echo "$FREETDS_MD5  $FREETDS_FILENAME" > freetds.md5; \
    md5sum --check freetds.md5; \
    tar -xzf $FREETDS_FILENAME; \
    cd $FREETDS_DIRNAME; \
    ./configure; \
    make; \
    make install; \
    cd /; \
    rm -rf FREETDS_BUILD_DIR; \
    apt-get remove -y curl build-essential make gcc; \
    apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*
