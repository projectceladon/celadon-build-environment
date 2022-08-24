# celadon-build-environment

Celadon Build Environment provides all the necessary packages and environment to download and build Celadon quickly in a containerized environment irrespective of the host operating system of the developer. This allows developers to seemlessly try building Celadon for his/her requirements and get started to develop with very minimal setup time.

## Features
1. This provides developer a clean build environment that he/she can readily use in their existing environment.
2. This ensures that developer does not have to make any upgrades or changes in the host environment and hence developer can try celadon building without any changes to host environment.
3. This provides an easy mechanism to track any changes with respect to celadon build environment and ensures that all developers are using the same envrionment while building celadon. This makes it easier for everyone to debug issues occurring in developer environment. 

## How To Use

Celadon build environment provides a Dockerfile which contains all the required packages. Hence a developer is expected to build a docker container using the Dockerfile and then use the same for building Celadon. 

### Prerequisite to build celadon-build-environment
1. Any GNU/Linux based Operating System as Host OS
2. Docker package installed and user running the build commands should be part of docker group.
3. Atleast 400 GB of free space in the system where the code will be synced and build.

### Step 1: Get latest Dockerfile
To get started, we expect the developer to have synced the latest Dockerfile by cloning the celadon-build-environment github repository.

`git clone https://github.com/projectceladon/celadon-build-environment`

### Step 2: Build docker image
User can now build the docker image. Please note that this might take sometime as the commands tries to install various package dependencies to create the docker image.

`docker build celadon-build-environment`

Once completed, the output should display the ID of the image generated. Please copy the same and replace below where `<ID>` is mentioned.

### Step 3: Tag docker image

Please tag the docker image generated in Step 2 by running the following command:

`docker tag <ID> celadon-build-environment:latest`

Please note `celadon-build-environment:latest` is now generated and can be used to run as a container to get an environment to download and build Celadon.

### Step 4: Create workspace directory in HOST OS
Before running the docker image, `celadon-build-environment:latest` it is important to create a workspace directory in HOST OS, so that the codebase synced does not get deleted if the container is stopped and can be used for future purposes.

For the same, please create a directory in your local hard disk and set its full path to the environment variable WORKSPACE.

`export WORKSPACE=<full-path-to-directory>`

Since WORKSPACE will be used by local user inside the container image, it is important to give full write and execute permissions to all users for this directory.

`chmod -R 777 $WORKSPACE`

### Step 5: Run celadon-build-environment along with volume mount of WORKSPACE

We have the container image, `celadon-build-environment:latest` and workspace directory `$WORKSPACE` ready. Let us use both of them to start the container.

`docker run --privileged -it -v $WORKSPACE:/data/ celadon-build-environment:latest /bin/bash`

This should give you a BASH prompt as `celadon` user. Change directory to `data` which will be the path for WORKSPACE directory inside the container.

`cd /data`

### Step 6: Init and Sync the Celadon codebase

You can now follow the steps to get the Celadon codebase and build it as mentioned in the [official Celadon documentation given here](https://docs.01.org/celadon/getting-started/build-source.html#build-c-in-vm-with-android-12).

## Contact Us

In case of any issues in setting up celadon-build-environment or suggestions on how we can improve, kindly contact us through the [Celadon Mailing list](https://lists.01.org/postorius/lists/celadon.lists.01.org/).
