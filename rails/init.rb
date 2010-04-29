require 'smart_cookie_store'

if Rails.version == '2.3.5'
  
  class ActionController::Response

    def convert_cookies!
      cookies = Array(headers['Set-Cookie']).compact
      headers['Set-Cookie'] = cookies unless cookies.empty?
    end
  end
  
end
