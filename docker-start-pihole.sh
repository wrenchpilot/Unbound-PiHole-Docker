#!/bin/bash

docker run -d \
    --user=root \
    --name pihole \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BIND_SERVICE \
    --restart=unless-stopped \
    -p 53:53/tcp \
    -p 53:53/udp \
    -p 5353:5353/tcp \
    -p 80:80 \
    -p 443:443 \
    wrenchpilot/unbound-pihole:4.3.2_ubuntu

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://127.0.0.1/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start, consult check your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;
