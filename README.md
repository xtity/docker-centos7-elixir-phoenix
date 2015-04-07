# docker-centos7-elixir-phoenix

This is a Docker image project with CentOS 7, Elixir, and Phoenix.  

## Requirement
### Installed these
* __boot2docker__
    * How to install
        * Mac
            * ```brew cask install boot2docker```
        * Windows
            * See http://boot2docker.io/

## Demo
```bash
## Clone this Project.
git clone git@github.com:xtity/docker-centos7-elixir-phoenix.git

## CD
cd docker-centos7-elixir-phoenix

## Init boot2docker
boot2docker init

## Run boot2docker
boot2docker up

## Build App Server Image
docker build -t local/project .

## Run App Server
docker run -d -p 80:4000 --name phoenix -t local/project

## Get Virtual Machine's IP & Access!!
boot2docker ip
```

## Usage
See the Demo. But if you already know the [DockerHub](https://registry.hub.docker.com/u/xtity/docker-centos7-elixir-phoenix/), the usage is Super Easy. Take a look below.

```bash
## Run Phoenix Server
docker run -d -p 80:4000 --name phoenix -t xtity/docker-centos7-elixir-phoenix
```
__Just 1 steps__ to make a VM with Elixir and Phoenix :)

## TIPS
### boot2docker setting
The boot2docker requires these environmental variables.

* DOCKER_CERT_PATH
* DOCKER_TLS_VERIFY
* DOCKER_HOST

We could ```export``` these vars in every time we use boot2docker.
But This way isn't handy.  
For example, you could execute the below command to set these in ```.bash_profile```.  

```bash
echo -e '\n# boot2docker config\nif [ "`boot2docker status`" = "running" ]; then\n    $(boot2docker shellinit 2>/dev/null)\nfi\n' >> ~/.bash_profile
```

Try it :)

## Licence

[The MIT License (MIT)](https://github.com/xtity/docker-centos7-elixir-phoenix/blob/master/LICENSE)

## Author

[xtity](https://github.com/xtity)
