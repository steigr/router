# Router

Configures and reloads Nginx. Please install a recent version of nginx (>=1.8) and
make sure the binary is in your PATH.

Futher a Docker must be reachable under /var/run/docker.sock, tcp://DEFAULT_GATEWAY:2375, or may be given with DOCKER_HOST environment variable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'router', github: 'steigr/router'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install router
