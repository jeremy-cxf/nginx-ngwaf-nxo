# VERSION corresponds to either the explcit version of nginx. e.g 1.25.5
# Avoid using `mainline` for this variable, given expectations of a module build being available
# the exact moment a new tag is released is unrealistic. 
ARG VERSION
FROM nginx:${VERSION}-alpine-slim

## Add NGWAF Pub keys
RUN apk --no-cache add wget
RUN wget -q https://apk.signalsciences.net/sigsci_apk.pub && \
    mv sigsci_apk.pub /etc/apk/keys/

## Add upstream APK repository
## Only update the ngwaf repository.
RUN . /etc/os-release && \
    m_version=$(echo $VERSION_ID | sed -n 's/^\([0-9]*\.[0-9]*\).*/\1/p') && \
    echo https://apk.signalsciences.net/3.19/main | tee -a /etc/apk/repositories && \
    apk update --repository=https://apk.signalsciences.net/$m_version/main

RUN nginx_version=$(nginx -v 2>&1 | awk -F' ' '{print $3}' | cut -d / -f 2) && \
    apk add nginx-module-sigsci-nxo-$nginx_version

## You can add the module here via sed, or you can do it via configuration management.
RUN sed -i 's@^pid.*@&\nload_module /usr/lib/nginx/modules/ngx_http_sigsci_module.so;\n@' \
    /etc/nginx/nginx.conf