FROM nginx:1.17.4

EXPOSE 8081

USER root

# support running as arbitrary user which belongs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    addgroup nginx root

COPY nginx.conf                 /etc/nginx/
COPY conf.d/                    /etc/nginx/conf.d/