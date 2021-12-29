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
ts=$(date +%s)
if [ -f "$addonfile" ]; then
  addondir="extracts/addons/$addon-$gameversion/Interface/AddOns"
  mkdir -p "$addondir"
  unzip -qq -o -d "$addondir" "$addonfile"
  for d in "$addondir"/*; do
    out="mount/logs/$product-$addon-$(basename "$d")-$ts.txt"
    env HOME=/root /usr/local/bin/lua wowless.lua "$loglevel" "$product" "$gameversion" "$d" > "$out"
    echo "$out"
  done
else
  out="mount/logs/$product-$ts.txt"
  env HOME=/root /usr/local/bin/lua wowless.lua "$loglevel" "$product" "$gameversion" > "$out"
  echo "$out"
fi
