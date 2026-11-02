# Define the base image
FROM nginx:latest
# Define creator and Maintainer of this image
MAINTAINER Sansy Bah <sansy.bah25@gmail.com>
# copy the file from the current host directory to the container
COPY index.html /usr/share/nginx/html/index.html
