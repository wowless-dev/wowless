cd wowless || exit
loglevel=$1
product=$2
gameversion=$3
addon=$4
rm -rf extracts out
mkdir extracts out
export HOME=/root
alias gsutil="CLOUDSDK_PYTHON=/usr/bin/python3 gsutil"
gsutil -m rsync -u gs://wowless.dev/luadbd "$HOME"/.cache/luadbd
gsutil -m cp \
  "gs://wowless.dev/extracts/$product.txt" \
  "gs://wowless.dev/addons/$addon-$gameversion.zip" \
  extracts
version=$(cat "extracts/$product.txt")
gsutil -m cp \
  "gs://wowless.dev/extracts/$version.zip" \
  "gs://wowless.dev/gscrapes/$version.lua" \
  extracts
unzip -qq -o -d extracts "extracts/$version.zip"
lua tools/gextract.lua "extracts/$version.lua" > "extracts/$version/Interface/GlobalEnvironment.lua"
ln -sf "$version" "extracts/$product"
addonfile="extracts/$addon-$gameversion.zip"
ts=$(date +%s)
if [ -f "$addonfile" ]; then
  addondir="extracts/addons/$addon-$gameversion/Interface/AddOns"
  mkdir -p "$addondir"
  ln -sf "$addon-$gameversion/Interface/AddOns" "extracts/addons/$gameversion"
  unzip -qq -o -d "$addondir" "$addonfile"
  for d in "$addondir"/*; do
    out="$product-$addon-$(basename "$d")-$ts.txt"
    env HOME=/root bin/run.sh --product "$product" --loglevel "$loglevel" --addondir "$d" > "out/$out"
    gsutil cp "out/$out" "gs://wowless.dev/logs/$out"
    echo "gs://wowless.dev/logs/$out"
  done
else
  out="$product-$ts.txt"
  env HOME=/root bin/run.sh --product "$product" --loglevel "$loglevel" > "out/$out"
  gsutil cp "out/$out" "gs://wowless.dev/logs/$out"
  echo "gs://wowless.dev/logs/$out"
fi
