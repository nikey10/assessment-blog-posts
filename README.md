## Installation

Use bundler to install required gems:

```
bundle install
```
## APIs
- http://localhost:3000/api/v1/ping
- http://localhost:3000/api/v1/posts

## Controllers
```
class Api::V1::PingController < ApplicationController
```

```
class Api::V1::PostsController < ApplicationController
```

## Caching
Install Redis depending on your operating system - [Redis](https://redis.io/)

Add the following line to Gemfile:
```
gem 'redis', '~> 4.0'
```
And add the following code to development.rb:
```
Rails.application.configure do
  config.cache_store = :redis_cache_store, { url: "redis://localhost:6379/0" }
end
```

## Concurrent Request
Add the following line to Gemfile:
```
gem 'typhoeus', '~> 1.4'
```
And invoke following method:
```
Api::V1::PostsController#concurrent_crawl
```

## Running
```
rails s 
```

The application will be available on [localhost:3000](http://localhost:3000)
