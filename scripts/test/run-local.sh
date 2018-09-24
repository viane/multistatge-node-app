#stop previous container
runing_container=$(docker ps -q --filter ancestor=loopback-app )
if [ ! -z "$runing_container" ]
then
    docker stop $(docker ps -q --filter ancestor=loopback-app )
fi

#run new build image
docker run -d -p 8080 loopback-app:latest

#display port info
maped_port=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' $(docker ps -q --filter ancestor=loopback-app))

echo "App is running at localhost:$maped_port/explorer"