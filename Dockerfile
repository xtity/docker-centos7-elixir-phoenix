########## OS ##########
FROM centos:centos7

RUN yum update -y && yum clean all
RUN yum reinstall -y glibc-common
########## OS ##########


########## ENV ##########
# Set the locale(en_US.UTF-8)
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Set the locale(ja_JP.UTF-8)
#ENV LANG ja_JP.UTF-8
#ENV LANGUAGE ja_JP:ja
#ENV LC_ALL ja_JP.UTF-8

# Set app env
ENV HOME /root
ENV ELIXIR_VERSION 1.0.3
ENV PHOENIX_APP_NAME sample
ENV PHOENIX_APP_PORT 4000
########## ENV ##########


########## MIDDLEWARE ##########
WORKDIR /usr/local/src

RUN yum install -y gcc gcc-c++ make openssl-devel ncurses-devel
RUN yum install -y epel-release && yum clean all
RUN yum install -y http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_3_general/esl-erlang_17.4-1~centos~7_amd64.rpm && yum clean all
RUN yum install -y git && yum clean all
########## MIDDLEWARE ##########


########## ELIXIR ##########
RUN git clone https://github.com/elixir-lang/elixir.git
WORKDIR /usr/local/src/elixir
RUN git checkout refs/tags/v${ELIXIR_VERSION}
RUN make clean install
########## ELIXIR ##########


########## PHOENIX ##########
# Install nodejs, npm
RUN yum install -y nodejs
RUN yum install -y npm

# Install phoenix
EXPOSE ${PHOENIX_APP_PORT}

WORKDIR /usr/local/src
RUN git clone https://github.com/phoenixframework/phoenix.git
WORKDIR /usr/local/src/phoenix/installer
RUN mix test
RUN mix phoenix.new /usr/local/src/${PHOENIX_APP_NAME}

# Create phoenix project
WORKDIR /usr/local/src/${PHOENIX_APP_NAME}
RUN npm install
RUN npm install -g brunch
RUN brunch build

# Compile phoenix(FOR dev)
#RUN yes | mix local.hex && yes | mix local.rebar && mix do deps.get, compile
# Compile phoenix(FOR prod)
RUN yes | mix local.hex && yes | mix local.rebar && mix do deps.get && MIX_ENV=prod mix compile.protocols
########## PHOENIX ##########


########## ON BOOT ##########
# Run Phoenix on Cowboy server(FOR dev)
#CMD ["/bin/bash", "-c", "mix phoenix.server"]
# Run Phoenix on Cowboy server(FOR prod)
CMD ["/bin/bash", "-c", "MIX_ENV=prod PORT=${PHOENIX_APP_PORT} elixir -pa _build/prod/consolidated -S mix phoenix.server"]
########## ON BOOT ##########

