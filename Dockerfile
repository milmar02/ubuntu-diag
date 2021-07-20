FROM ubuntu:latest

LABEL name="ubuntu-diag" \
    vendor="Ubuntu" \
    os-version="latest" \
    license="GPLv2" \
    build-date="20170717" \
    oc-client-version="v1.5.1-7b451fc-linux-64bit" \
    kubectl-version="1.7.0" \
    maintainer="martin@2mnet.de" 

RUN apt-get update
RUN apt-get -y install --no-install-recommends wget gnupg ca-certificates
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
| tee /etc/apt/sources.list.d/openresty.list
RUN apt-get -y install openresty
RUN apt-get install -y libssl-dev perl make build-essential curl
RUN ap-get install -y \
wget \
nmap \
maven \
git \
ping \
telnet \
curl \
openssl \
&& wget -q https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl -O /bin/kubectl \
&& chmod 755 /bin/kubectl \
&& mkdir /bin/oc_client \
&& wget -q https://github.com/openshift/origin/releases/download/v1.5.1/openshift-origin-client-tools-v1.5.1-7b451fc-linux-64bit.tar.gz -O /bin/oc_client/oc_client.tar.gz \
&& tar -zxvf /bin/oc_client/oc_client.tar.gz -C /bin/oc_client/ \
&& mv /bin/oc_client/openshift-origin-client-tools-v1.5.1-7b451fc-linux-64bit/oc /bin/ \
&& rm -rf /bin/oc_client \ 
&& wget -q https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template.lua -O /usr/local/openresty/site/lualib/template.lua \
&& ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
&& ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log 

ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD entrypoint.sh /entrypoint.sh

RUN chmod -R g+w /usr/local/openresty \
&& chmod g+x /entrypoint.sh

USER root


EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]

