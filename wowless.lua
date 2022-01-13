local ngx = require('ngx')
local args = ngx.req.get_uri_args()
local map = {
  wow = 'Mainline',
  wowt = 'Mainline',
  wow_classic = 'TBC',
  wow_classic_era = 'Vanilla',
  wow_classic_era_ptr = 'Vanilla',
  wow_classic_ptr = 'TBC',
}
local product = args.product
if not product or not map[product] then
  return ngx.exit(400)
end
local loglevel = tonumber(args.loglevel or 0)
if not loglevel then
  return ngx.exit(400)
end
local addon = args.addon or 0
local f = io.popen(('sh query.sh %d %s %s %d'):format(loglevel, product, map[product], addon))
local content = f:read('*all')
f:close()
ngx.print(content)
