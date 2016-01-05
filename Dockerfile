FROM ubuntu:14.04
MAINTAINER Medley,inc. <info@medley.jp>

ENV RubyVersion 2.2.2

# Run upgrades
RUN echo deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse >> /etc/apt/sources.list;\
  echo deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe >> /etc/apt/sources.list;\
  echo deb http://security.ubuntu.com/ubuntu precise-security main restricted universe >> /etc/apt/sources.list;\
  echo udev hold | dpkg --set-selections;\
  echo initscripts hold | dpkg --set-selections;\
  echo upstart hold | dpkg --set-selections;\
  apt-get update;\
  apt-get -y upgrade && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* 

# Install dependencies
RUN apt-get update && apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev sudo python python-docutils python-software-properties nginx logrotate postfix mysql-client libmysqlclient-dev --no-install-recommends

# Install Git
RUN add-apt-repository -y ppa:git-core/ppa;\
  apt-get update;\
  apt-get -y install git

# Install Ruby
RUN mkdir /tmp/ruby;\
  cd /tmp/ruby;\
  curl ftp://ftp.ruby-lang.org/pub/ruby/2.2/ruby-${RubyVersion}.tar.gz | tar xz;\
  cd ruby-${RubyVersion};\
  chmod +x configure;\
  ./configure --disable-install-rdoc;\
  make;\
  make install;\
  gem install bundler --no-ri --no-rdoc

# Create a user
RUN adduser --disabled-login --gecos 'S3Gyazo' gyazo
RUN apt-get install -y vim w3m wget zsh tmux lv && adduser gyazo sudo 

ADD sinatra_app /home/gyazo
RUN cd /home/gyazo && bundle install 
RUN mkdir /home/gyazo/import

# RUN cd /home/gyazo && chown -R gyazo:gyazo . && su gyazo -c "bundle install"

EXPOSE 80
EXPOSE 22

# expected to mount this directory
CMD ["/home/gyazo/import/run.sh"]


