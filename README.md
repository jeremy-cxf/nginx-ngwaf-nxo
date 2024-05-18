# nginx-ngwaf-nxo

Container mirroring nginx.org dockerhub with the ngwaf (aka sigsci) module installed. This was mainly for my own development purposes, but realised, there lacks an image officially.

## How do I modify this image? 
A multi stage build would be better advised, if for some reason you have to, the only thing this container expects is a ${VERSION} to be provided in a `--build-arg`. 

This is recommended to be the semantic version of nginx you are deploying. Given this nginx is inclusive of a third party module, and the way third party modules need to be compiled against nginx, if you are running latest tags inside nginx, then it is very unlikely we may have a module available the moment a new tag is released, however the actions that have been built check for both.