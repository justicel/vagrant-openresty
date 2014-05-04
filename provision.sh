if ! grep -Fxq 'Europe/Amsterdam' /etc/timezone
then
  echo "Europe/Amsterdam" >/etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  apt-get install -y git zip
fi

if [ ! -d /etc/postgres ]
then
  apt-get update
  apt-get install -y postgresql-9.3 postgresql-contrib-9.3 libpq-dev
fi

if [ ! -d /usr/local/openresty/nginx ]
then
  cd ~
  wget -nv http://openresty.org/download/ngx_openresty-1.5.12.1.tar.gz
  tar xfz ngx_openresty-1.5.12.1.tar.gz
  cd ngx_openresty-1.5.12.1/
  apt-get install -y build-essential libreadline6-dev libpcre3-dev libssl-dev git
  ./configure --with-luajit --with-http_postgres_module --with-http_iconv_module
  make
  make install
  ln -s  /usr/local/openresty/luajit/bin/luajit-2.1.0-alpha /usr/local/openresty/luajit/bin/luajit
fi

if [ ! -f /usr/local/openresty/luajit/luarocks ]
then
  cd ~
  wget -nv http://luarocks.org/releases/luarocks-2.1.2.tar.gz
  tar xfz luarocks-2.1.2.tar.gz
  cd luarocks-2.1.2/
  ./configure --prefix=/usr/local/openresty/luajit \
    --with-lua=/usr/local/openresty/luajit/ \
    --lua-suffix=jit-2.1.0-alpha \
    --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
  make build
  make install

  cat <<SH >>/home/vagrant/.profile
# OpenResty
PATH=/usr/local/openresty/nginx/sbin:\$PATH
PATH=/usr/local/openresty/luajit/bin:\$PATH
export PATH
SH

fi

if [ ! -f /usr/bin/tup ]
then
  apt-add-repository 'deb http://ppa.launchpad.net/anatol/tup/ubuntu precise main'
  apt-get update
  apt-get install -y --force-yes tup
fi

if [ ! -f /usr/local/openresty/luajit/bin/lapis ]
then
  /usr/local/openresty/luajit/bin/luarocks install lapis
  /usr/local/openresty/luajit/bin/luarocks install moonscript
fi
