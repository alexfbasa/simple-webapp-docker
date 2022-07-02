# You must set worker processes based on your CPU cores, nginx does not benefit from setting more than that,
# Some last versions calculate it automatically
worker_processes auto;

# number of file descriptors used for nginx, the limit for the maximum FDs on the server is usually set by the OS.
# if you don't set FD's then OS settings will be used which is by default 2000
worker_rlimit_nofile 100000;

events {
    # determines how much clients will be served per worker
    # max clients = worker_connections * worker_processes
    # max clients is also limited by the number of socket connections available on the system (~64k)
    # 3500 * 3 (nginx) =  10500 connections
    worker_connections  3500;
}

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    client_max_body_size 75m;
    map_hash_max_size 262144;
    map_hash_bucket_size 262144;
    include /etc/nginx/conf.d/*.conf;
}