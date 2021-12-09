# Build flask-app image
docker build -t flask-app .

# Run flask-app container
docker run -d -p 6000:6000 --name flask-app flask-app