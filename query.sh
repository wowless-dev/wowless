cd wowless || exit
loglevel=$1
product=$2
gameversion=$3
addon=$4
version=$(cat "mount/extracts/$product.txt")
mkdir -p extracts
unzip -qq -o -d extracts "mount/extracts/$version.zip"
lua tools/gextract.lua "mount/gscrapes/$version.lua" > "extracts/$version/Interface/GlobalEnvironment.lua"
ln -sf "$version" "extracts/$product"
addonfile="mount/addons/$addon-$gameversion.zip"
if [ -f "$addonfile" ]; then
  addondir="extracts/addons/$addon-$gameversion/Interface/AddOns"
  mkdir -p "$addondir"
  unzip -qq -o -d "$addondir" "$addonfile"
  for d in "$addondir"/*; do
    env HOME=/root /usr/local/bin/lua wowless.lua "$loglevel" "$product" "$gameversion" "$d" > "mount/logs/$product-$addon-$(date +%s).txt"
  done
else
  env HOME=/root /usr/local/bin/lua wowless.lua "$loglevel" "$product" "$gameversion" > "mount/logs/$product-$(date +%s).txt"
fi
