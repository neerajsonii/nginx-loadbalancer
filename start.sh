#!/usr/bin/env bash

# declaring variables
watch_flag="--watch"
do_watch=true;
main_file="app.js" # put your path to main file.
nginx_dir="/usr/local/etc/nginx" # put your path to nginx directory location ( this is for mac).
port_collection=(4444 4445 4446 4447 4448)


boot() {
    pm2 start $main_file --name server-$1  -f -- $1 --watch
}

main() {
    dt=`date`
    echo
    echo $dt
    echo
    echo "Welcome to Load balancing demo with Nginx"

    for port in "${port_collection[@]}"
    do
        echo "Booting up app server on port : $port"
        boot $port
        echo "------- ------- ------"
    done
}

removeExistingLoadBalancer() {
    rm -rf $nginx_dir/load-balancer.conf
}

configureNginxLodBalancer() {
    # Removing existing load balancer file if exists
    removeExistingLoadBalancer
    
    # copy your loadbalancer file to nginx directory
    cp ./load-balancer.conf $nginx_dir
    
    # test you nginx config
    sudo nginx -t 

    # Reloading nginx
    sudo nginx -s reload
    
    echo
    echo "Nginx Load Balancer configured"
}

showLogs() {
    pm2 logs
}

showProcessList() {
    pm2 ls
}

main
# configureNginxLodBalancer
showProcessList
showLogs