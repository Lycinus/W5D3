require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @session_cookies = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @session_cookies = {}
    end
  end

  def [](key)
    @session_cookies[key]
  end

  def []=(key, val)
    @session_cookies[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app', {path: "/", value: "#{@session_cookies.to_json}"})
  end
end
