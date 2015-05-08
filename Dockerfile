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
ENV ELIXIR_VERSION 1.0.4
ENV PHOENIX_APP_NAME sample
# ENV PHOENIX_APP_REPO https://github.com/phoenixframework/phoenix.git
ENV PHOENIX_APP_PORT 4000
########## ENV ##########


########## MIDDLEWARE ##########
WORKDIR /usr/local/src

RUN yum install -y gcc gcc-c++ make openssl-devel ncurses-devel
RUN yum install -y epel-release && yum clean all
RUN yum install -y http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_3_general/esl-erlang_17.5-1~centos~7_amd64.rpm && yum clean all
RUN yum install -y git && yum clean all
########## MIDDLEWARE ##########


########## ELIXIR ##########
# Build Elixir
RUN git clone https://github.com/elixir-lang/elixir.git
WORKDIR /usr/local/src/elixir
RUN git checkout refs/tags/v${ELIXIR_VERSION}
RUN make clean install

# Build Mix Tasks to use Dialyxir
WORKDIR /usr/local/src
RUN git clone --depth 2 https://github.com/jeremyjh/dialyxir.git
WORKDIR /usr/local/src/dialyxir
RUN mix archive.build
RUN yes | mix archive.install dialyxir-0.2.6.ez && mix dialyzer.plt
########## ELIXIR ##########


########## PHOENIX ##########
# Install nodejs, npm
RUN yum install -y nodejs
RUN yum install -y npm

# Expose phoenix app port
EXPOSE ${PHOENIX_APP_PORT}

# Install original phoenixframework
RUN mkdir -p /usr/local/src/phoenix/origin
WORKDIR /usr/local/src/phoenix/origin
RUN git clone https://github.com/phoenixframework/phoenix.git
WORKDIR /usr/local/src/phoenix/origin/phoenix/installer
RUN MIX_ENV=prod mix archive.build
RUN yes | mix archive.install

# Install phoenix app
RUN mkdir -p /usr/local/src/phoenix/app
WORKDIR /usr/local/src/phoenix/app

# Create new phoenix app
RUN mix phoenix.new ${PHOENIX_APP_NAME}

# Clone phoenix app
#RUN git clone ${PHOENIX_APP_REPO}

# Setup phoenix app
WORKDIR /usr/local/src/phoenix/app/${PHOENIX_APP_NAME}
RUN npm install
RUN npm install -g brunch
RUN brunch build

# Add exrm dependency
RUN sed -i "s/\({:cowboy,.*}\)]/\1, {:exrm, \"~> 0.14.16\"}]/g" mix.exs

# Set phoenix server to start automatically
RUN sed -i "s/^config\(.*\).Endpoint,/config \1.Endpoint, server: true,/g" config/prod.exs

# Compile phoenix(FOR dev)
#RUN yes | mix local.hex && yes | mix local.rebar && mix do deps.get, compile
# Compile phoenix(FOR prod)
RUN yes | mix local.hex && yes | mix local.rebar && mix do deps.get && mix phoenix.digest && MIX_ENV=prod mix release
########## PHOENIX ##########


########## ON BOOT ##########
# Run Phoenix on Cowboy server(FOR dev)
#CMD ["/bin/bash", "-c", "mix phoenix.server"]
# Run Phoenix on Cowboy server(FOR prod)
CMD ["/bin/bash", "-c", "PORT=${PHOENIX_APP_PORT} rel/${PHOENIX_APP_NAME}/bin/${PHOENIX_APP_NAME} foreground"]
########## ON BOOT ##########

