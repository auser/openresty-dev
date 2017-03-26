require "busted.runner"()
local fakengx   = require("vendor.fakengx")
local index     = require("pages.index")

DEFAULT_URL = '/'

describe("pages", function()
  describe('index', function()
    before_each(function()
      ngx = fakengx.new()
    end)

    it('sanity local thing', function()
      index.run()
      assert.same(ngx._exit, 200)
      assert.equal(ngx._body, "Welcome\n")
    end)

  end)

end)