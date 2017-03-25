require 'busted.runner'()
local index = require("index")

DEFAULT_URL = '/'

describe("Sanity test", function()
  it("should be true", function()
    local res = index.run()
    -- local res = ngx.location.capture(DEFAULT_URL,{method=ngx.HTTP_GET})
    -- print(res.status)
    -- print(res.body)
    assert.are.equals(res, "Welcome")
  end)
end)