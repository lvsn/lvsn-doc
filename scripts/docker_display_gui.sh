# take rach as an example. First of first, use x2go to login to rach.
# run the following cmds or modify/run this scrip to enable display forward from docker to rach
# replace the following 3 lines to any file you want. The path_name is not ended with '/'
MOUNT_SRC=/gel/usr/jizha16/Desktop
MOUNT_DST=/root/sharedDockerFiles
dockerImage=nvidia/cuda:10.0-cudnn7-devel
## you can add more monut point if needed
docker run -it -d \
    --volume="$MOUNT_SRC:$MOUNT_DST" \
    --net=host \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    $dockerImage \
    bash

echo Docker container will restart
export containerId=$(docker ps -l -q)
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $containerId`
docker start $containerId

echo copy Xauthority data
cp ~/.Xauthority $MOUNT_SRC
docker exec -it $containerId bash -c "cp $MOUNT_DST/.Xauthority ~/"
rm $MOUNT_SRC/.Xauthority

docker restart $containerId
# attach to the docker container
# docker attach $containerId
# inside docker
# gedit  # this will display on your x2go screen (if gedit is installed in the container)
echo (Success) then you can attach to the container, run any GUI application, the window will appear in your x2go screen.
