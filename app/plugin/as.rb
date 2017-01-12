module Cuba::Sugar
  module As
    def as(http_code = 200, extra_headers = {}, &block)
      res.status = http_code
      res.headers.merge! extra_headers
      res.write yield if block
    end
    
    def as_json(http_code = 200, extra_headers = {}, &block)
      require 'json'
      extra_headers["Content-Type"] ||= "application/json"
      as(http_code, extra_headers) { yield.to_json if block }
    end
  end
end
