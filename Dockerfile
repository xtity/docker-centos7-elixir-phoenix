FROM centos:centos7

RUN yum update -y && yum clean all

# Set the locale
RUN yum reinstall -y glibc-common
#ENV LANG ja_JP.UTF-8
#ENV LANGUAGE ja_JP:ja
#ENV LC_ALL ja_JP.UTF-8

#RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Set HOME
ENV HOME /root
WORKDIR /usr/local/src

RUN yum install -y gcc gcc-c++ make openssl-devel ncurses-devel
RUN yum install -y epel-release && yum clean all
RUN yum install -y wget && yum clean all
RUN yum install -y http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_3_general/esl-erlang_17.4-1~centos~7_amd64.rpm && yum clean all
# RUN yum install -y erlang && yum clean all
RUN yum install -y git && yum clean all

# install elixir
ENV ELIXIR_VERSION 1.0.3

RUN git clone https://github.com/elixir-lang/elixir.git
WORKDIR /usr/local/src/elixir
RUN git checkout refs/tags/v${ELIXIR_VERSION}
#RUN make clean test
RUN make clean install

#RUN ln -s /elixir/bin/elixirc /usr/local/bin/elixirc && \
#    ln -s /elixir/bin/elixir /usr/local/bin/elixir && \
#    ln -s /elixir/bin/mix /usr/local/bin/mix && \
#    ln -s /elixir/bin/iex /usr/local/bin/iex

# install nodejs, npm
RUN yum install -y nodejs
RUN yum install -y npm

# install phoenix
ENV PHOENIX_APP_NAME sample
ENV PHOENIX_APP_PORT 4000
EXPOSE ${PHOENIX_APP_PORT}

WORKDIR /usr/local/src
RUN git clone https://github.com/phoenixframework/phoenix.git
WORKDIR /usr/local/src/phoenix/installer
RUN mix test
RUN mix phoenix.new /usr/local/src/${PHOENIX_APP_NAME}

WORKDIR /usr/local/src/${PHOENIX_APP_NAME}
#RUN yes | mix deps.get
RUN npm install
RUN yes | mix local.hex && yes | mix local.rebar && mix do deps.get, compile
#RUN yes | mix local.hex
#RUN yes | mix local.rebar
#RUN yes | mix do deps.get, compile
#RUN mix do deps.get
#RUN mix phoenix.server
#ENTRYPOINT echo '######################### INITIALIZE RAILS PROJECT #########################'
#CMD ["cd", "/usr/local/src/sample"]
#CMD ["elixir", "--detached", "-S", "mix", "phoenix.server"] 
#CMD ["iex"]
#RUN yes | mix deps.get
#ENV MIX_ENV prod
#RUN yes | mix
#RUN PORT=${PHOENIX_APP_PORT} elixir -pa _build/prod/consolidated -S mix phoenix.server

# EXPOSE 4369

#ENTRYPOINT cd /usr/local/src/sample/ && \
#           elixir --detached -S mix phoenix.server
#    mix server.phoenix
#    elixir --detached -S mix phoenix.server

# CMD pwd

#CMD /bin/bash && \
#CMD cd /usr/local/src/sample && \
#    mix phoenix.server
#    elixir --detached -S mix phoenix.server

#CMD ["/bin/bash", "-c", "cd /usr/local/src/sample && elixir --detached -S mix phoenix.server"]



CMD ["/bin/bash", "-c", "mix phoenix.server"]
#CMD echo "PHOENIX IS RUNNING!"

#CMD /bin/bash -c mix phoenix.server

