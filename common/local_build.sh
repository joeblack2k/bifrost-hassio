cd ..
cp common/Dockerfile bifrost-edge/
cp -R common/rootfs bifrost-edge/
docker run --rm --privileged \
-v $(pwd)/bifrost-edge:/data homeassistant/amd64-builder --amd64 -t /data \
--no-cache
rm -rf bifrost-edge/rootfs
rm bifrost-edge/Dockerfile