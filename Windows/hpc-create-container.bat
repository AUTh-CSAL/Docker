SET CURRENTDIR="%cd%"
cd %~dp0..\..
SET UPDIR="%cd%"
cd %CURRENTDIR%
docker create -ti --name hpc -v %UPDIR%:/home/csal/pds hpcimage
