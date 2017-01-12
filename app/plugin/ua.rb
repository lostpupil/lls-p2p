module Cuba::Hawk
  HMS = NORAML_CONFIG["web"]["hms"]
  module Auth
    def gate_keeper
      if req[:auth_token].blank? or req[:user_id].blank?
        as_json 401 do
          {error: 'user_id or token required'}
        end
        halt(res.finish)
      end

      begin
        @decoded_token = JWT.decode req[:auth_token], HMS, true, { :algorithm => 'HS256' }
        if @decoded_token[0]['iss'] == req[:user_id]
          return @decoded_token[0]['iss']
        else
          as_json 401 do
            {error: 'user invalid'}
          end
          halt(res.finish)
        end
      rescue JWT::DecodeError
        as_json 401 do
          {error: 'token invalid'}
        end
        halt(res.finish)
      end
    end

    def build_token(user)
      payload = {iss: user.id, exp: Time.now.to_i + 3600 * 2 * 100}
      token = JWT.encode payload, HMS, 'HS256'
    end
  end
end
