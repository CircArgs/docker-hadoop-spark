FROM bde2020/spark-base:3.0.0-hadoop3.2

LABEL maintainer="Gezim Sejdiu <g.sejdiu@gmail.com>, Giannis Mouchakis <gmouchakis@gmail.com>"

COPY master.sh /

RUN apk update && apk upgrade
RUN apk add --no-cache bash\
                       python \
                       pkgconfig \
                       git \
                       gcc \
                       g++ \
                       openldap \
                       libcurl \
                       python3-dev \
                       gpgme-dev \
                       libc-dev \
    && rm -rf /var/cache/apk/*
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install jupyter

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_MASTER_LOG /spark/logs

EXPOSE 8080 7077 6066

CMD ["/bin/bash", "/master.sh"]
