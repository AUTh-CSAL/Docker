# Docker
Docker image for providing a unified computing system

# Installation of the CSAL Docker image

Note: This README assumes that there is already Docker installed on the host machine, either Windows, MacOS or Linux. For more info on how to obtain Docker, please visit:

https://www.docker.com/products/docker-desktop

Start by downloading the content of this repo, either through `git clone https://github.com/AUTh-csal/Docker.git` or by zip download here:
 
https://github.com/AUTh-csal/Docker/archive/main.zip 

Afterwards, by opening a terminal or Command Prompt, according to your host OS, navigate to the folder where the extracted data is (default extracted folder is `Docker`). There you can see the following directory structure (timestamps may vary!):

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
For Windows users, navigate to the `Windows` directory and then run `hpc-build-image.bat`, `hpc-create-container.bat` and `hpc-start-container.bat`. The screenshots below show the expected behavior.

![hpc-build-image](https://user-images.githubusercontent.com/16119641/95837809-54b33c80-0d41-11eb-8440-7519cede6621.png)

![hpc-create-container](https://user-images.githubusercontent.com/16119641/95837999-8cba7f80-0d41-11eb-9af9-5e94f56f3ceb.png)

![hpc-start-container](https://user-images.githubusercontent.com/16119641/95838179-c25f6880-0d41-11eb-82e7-40ef30f7ccb5.png)

For Linux and MacOS users, remain in this folder, run `hpc-build-image`, `hpc-create-container` and `hpc-start-container`.

# Pulling and building hello world examples for the course 050 - Parallel and Distrubuted Systems

After succesfully having build, created and ran the container, you should be able to see the following screen, called Welcome screen :)

![2020-10-13_10h54_58](https://user-images.githubusercontent.com/16119641/95838920-a8725580-0d42-11eb-9162-ca366f81d73b.png)

Then you can navigate to 

