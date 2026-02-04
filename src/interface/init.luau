local interface = setmetatable({}, {__index=require('@self/src_ecs')})
interface.Mapping = require('./map')
function interface:Source () return require('./') end

return interface