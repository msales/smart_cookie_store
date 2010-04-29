class SmartCookieStore < ActionController::Session::CookieStore
  
  def call(env)
    sh = ActionController::Session::AbstractStore::SessionHash
    env[ENV_SESSION_KEY] = sh.new(self, env)
    env[ENV_SESSION_OPTIONS_KEY] = @default_options.dup

    status, headers, body = @app.call(env)

    session_data = env[ENV_SESSION_KEY]
    options = env[ENV_SESSION_OPTIONS_KEY]

    if !session_data.is_a?(sh) || session_data.send(:loaded?) || options[:expire_after]
      session_data.send(:load!) if session_data.is_a?(sh) && !session_data.send(:loaded?)
      
      cookie = Hash.new

      session_keys = session_data.keys.reject {|k| k == :session_id }
      unless session_keys.empty? || session_keys.all? {|k| session_data[k].blank?}
        marshaled_session_data = marshal(session_data.to_hash)

        raise CookieOverflow if marshaled_session_data.size > MAX

        cookie[:value] = marshaled_session_data
        unless options[:expire_after].nil?
          cookie[:expires] = Time.now + options[:expire_after]
        end
      end
      cookie = build_cookie(@key, cookie.merge(options))
      unless headers[HTTP_SET_COOKIE].blank?
        headers[HTTP_SET_COOKIE] << "\n#{cookie}"
      else
        headers[HTTP_SET_COOKIE] = cookie
      end
    end

    [status, headers, body]
  end
  
end
