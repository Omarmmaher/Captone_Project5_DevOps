# Tag image
docker tag flask-app:latest omarmaher2909/flask-app:latest

# Login to docker-hub
docker login --username=omarmaher2909

# Push image
docker push omarmaher2909/flask-app:latest