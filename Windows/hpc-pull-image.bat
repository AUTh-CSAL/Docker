call docker pull authcsal/docker:latestgithubbase
call docker tag authcsal/docker:latestgithubbase hpcimage
call docker rmi -f authcsal/docker:latestgithubbase
