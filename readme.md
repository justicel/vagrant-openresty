# OpenResty with Lapis

```sh
vagrant ssh

cd /vagrant
mkdir project
cd project
lapis new --tup --git

cat <<CONFIG >config.moon
-- config.moon
import config from require "lapis.config"

config "development", ->
  port 8080

config "production", ->
  port 80
  num_workers 4
  lua_code_cache "off"
CONFIG

tup init
tup monitor -a
lapis server development
```

Visit `http://localhost:8888` and see `Welcome to Lapis 0.0.10!`.

More information:

https://www.youtube.com/watch?v=Eo67iTY1Yf8
