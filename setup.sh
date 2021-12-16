set -eo pipefail
echo deb http://packages.cloud.google.com/apt gcsfuse-buster main |
  tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg |
  apt-key add -
echo deb http://openresty.org/package/debian buster openresty |
  tee /etc/apt/sources.list.d/openresty.list
curl https://openresty.org/package/pubkey.gpg |
  apt-key add -
apt-get update
apt-get install -y gcsfuse libyaml-dev libzip-dev openresty tini
apt-get clean
python3 -m pip install hererocks
hererocks -l 5.1 -r 3.5.0 /usr/local
git clone https://github.com/lua-wow-tools/wowless
cd wowless
luarocks build
mkdir mount
ln -s $PWD/mount/luadbd /root/.cache/luadbd
