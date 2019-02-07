require 'rack'

app = Proc.new do |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new
    if req.path == '/i/love/app/academy'
        res.write('i have mixed feelings about app academy')
    else
        res.write('i like turtles')
    end
    res['Content-Type'] = 'text/html'
    res.finish
end

Rack::Server.start(
    app: app,
    Port: 3000
)