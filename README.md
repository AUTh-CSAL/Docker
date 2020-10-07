# Docker
Docker image for providing a unified computing system

# Installation

Note: This README assumes that there is already Docker installed on the host machine, either Windows, MacOS or Linux. For more info on how to obtain Docker, please visit: https://www.docker.com/products/docker-desktop
Start by downloading the content of this repo, either through `git clone https://github.com/AUTh-csal/Docker.git` or by zip download here: 
https://github.com/AUTh-csal/Docker/archive/main.zip 

Afterwards, by opening a terminal or Command Prompt, according to your host OS, navigate to the folder where the extracted data is. There you can see the following directory structure (timestamps may vary!):

```
2020-09-29  08:57    <DIR>          .
2020-09-29  08:57    <DIR>          ..
2020-10-07  15:12             3 703 Dockerfile
2020-09-29  08:57                47 hpc-build-image
2020-09-29  08:57                85 hpc-create-container
2020-09-29  08:57                89 hpc-start-container
2020-09-29  08:57                78 hpc-uninstall
2020-09-29  08:57               786 Welcome
2020-09-29  08:57    <DIR>          Windows
```
For Windows users, navigate to the `Windows` directory and then run `hpc-build-image.bat`, `hpc-create-container.bat` and `hpc-start-container.bat`.

For Linux and MacOS users, remain in this folder, run `hpc-build-image`, `hpc-create-container` and `hpc-start-container`.
