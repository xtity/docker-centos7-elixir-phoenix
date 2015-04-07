# docker-centos7-elixir-phoenix

This is a Docker image project with CentOS, Elixir, and Phoenix.  

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

## Licence

[The MIT License (MIT)](https://github.com/xtity/docker-centos7-elixir-phoenix/blob/master/LICENSE)

## Author

[xtity](https://github.com/xtity)
