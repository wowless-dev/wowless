set -eo pipefail
echo deb http://openresty.org/package/debian buster openresty |
  tee /etc/apt/sources.list.d/openresty.list
curl https://openresty.org/package/pubkey.gpg |
  apt-key add -
apt-get update
apt-get install -y libreadline-dev libssl-dev libyaml-dev libzip-dev m4 openresty unzip
apt-get clean
python3 -m pip install hererocks
hererocks -l 5.1 -r 3.5.0 /usr/local
git clone https://github.com/lua-wow-tools/wowless
cd wowless
luarocks build
mkdir -p /root/.cache/luadbd
