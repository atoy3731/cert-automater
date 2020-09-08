FROM centos:7

RUN yum update -y && \
    yum install -y openssl

COPY openssl.cnf /opt/openssl.cnf

RUN mkdir -p /etc/pki/CA && \
    touch /etc/pki/CA/index.txt && \
    echo 01 > /etc/pki/CA/serial

COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

CMD [ "/opt/entrypoint.sh" ]
