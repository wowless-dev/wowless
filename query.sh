cd wowless || exit
loglevel=$1
product=$2
gameversion=$3
version=$(cat "mount/extracts/$product.txt")
mkdir -p extracts
unzip -qq -o -d extracts "mount/extracts/$version.zip"
lua tools/gextract.lua "mount/gscrapes/$version.lua" > "extracts/$version/Interface/GlobalEnvironment.lua"
ln -sf "$version" "extracts/$product"
env HOME=/root /usr/local/bin/lua wowless.lua "$loglevel" "$product" "$gameversion"
