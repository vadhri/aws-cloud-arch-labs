### About
This project is a sample to demonstrate the following aspects of micro-front ends.

- Write a container ( root ) app.
- Write different apps (home, auth) as seperate web apps and link them into the container.
- Module fedration configuraiton to link all apps together in each module. 
- Upload to S3 and include CF using git workflows ( not in this folder at root of the git project.) 
- Inter app communication using callbacks, props for the react components.
- Lazyloading, language or settings change detection and propagation. 

Container [![deploy-container](https://github.com/vadhri/cloud-tech-notebook/actions/workflows/container.yml/badge.svg)](https://github.com/vadhri/cloud-tech-notebook/actions/workflows/container.yml)

Auth [![deploy-auth](https://github.com/vadhri/cloud-tech-notebook/actions/workflows/auth.yml/badge.svg)](https://github.com/vadhri/cloud-tech-notebook/actions/workflows/auth.yml)

Home [![deploy-home](https://github.com/vadhri/cloud-tech-notebook/actions/workflows/home.yml/badge.svg)](https://github.com/vadhri/cloud-tech-notebook/actions/workflows/home.yml)