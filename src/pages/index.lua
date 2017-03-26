module("index", package.seeall)

function index.run()
  ngx.say("Welcome")
  ngx.exit(200)
end

return index
