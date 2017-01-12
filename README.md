#cubanana

## Description

This is a dead simple api framework, built on top of several great gems like cuba, sequel. It seems like a framework, but you can call this is a template with several common file structure here. It's tiny, but functional.

## Define a model

Create a new file in `app/model` named 'dummy.rb' like below.

```ruby
class Dummy < Sequel::Model
end
```

## Define an api

Create a new file in `app/api` named 'v1.rb' like below.

```ruby
V1.define do
  on get do
    on root do
      as_json do
        {data: 'hello world'}
      end
    end
  end
  on post do
  end
```

## Define a plugin

Create a new file in `app/plugin` named 'as.rb' like below.

```ruby
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
```

## Define a middleware

Create a new file in `app/middleware` named `watchman` like below.

```ruby
class Watchman
  include Rack::Utils

  def initialize(app)
    @app = app
  end

  def call(env)
    status, @headers, resp = @app.call(env)
    [status, @headers, resp]
  end
end
```

Actually you can write whatever rack based middleware here to fulfill you own need.

## Task

I wrote some common tasks such as 

```bash
rake server # or default rake
rake c # this means you can have a rails like console here
rake test # this will execute tests in test folders.
rake db:migrate
rake db:rollback
rake db:version
rake db:reset
```