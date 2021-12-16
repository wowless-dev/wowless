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
local pipe = assert(io.popen(('sh query.sh %d %s %s 2>&1'):format(loglevel, product, map[product])))
local content = pipe:read('*all')
pipe:close()
ngx.print(content)