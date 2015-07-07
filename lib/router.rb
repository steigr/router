require "ostruct"
require "thor"
require "logger"
require "open3"
require "webrick"
require "json"
require "colorize"
require "docker"

require "router/version"
require "router/template"
require "router/options"

require "router/concerns/singleton"
require "router/concerns/logging"
require "router/concerns/checkable"
require "router/concerns/registerable"

require "router/command_runner"
require "router/eventable"
require "router/servicable"

require "router/events"
require "router/timer"
require "router/registry"
require "router/nginx"
require "router/rest"
require "router/docker"
require "router/service"

module Router
  include Logging
  class << self
    def start options={}, *arguments
      Thread.abort_on_exception = true
      Registry.add_callback nginx: {
        add: ->(nginx){nginx.update},
        remove: ->(nginx){nginx.update}
      }
      Registry.add_callback rest: {
        add: ->(rest){rest.start},
        remove: ->(rest){rest.stop}
      }
      Registry.add_callback docker: {
        add: ->(docker){
          docker.inventorize
          docker.watch
        },
        remove: ->(docker){docker.unwatch}
      }
      Registry.add_callback service: {
        add: ->(service)    {service.watch},
        remove: ->(service) {service.unwatch}
      }
      Rest.create
      Nginx.create
      Docker.create
      wait
    end
    def stop
      log info: "shutdown"
      Registry.stores.each do |category,components|
        components.each do |id,component|
          log debug: component.inspect
          component.remove
        end
      end
      Thread.list[1..-1].each do |thread|
        thread.kill
      end
    end
    def wait
      begin
        log info: "ready".green
        IO.select([IO.pipe[0]],nil)
      rescue Interrupt, SystemExit
        stop
      rescue Exception => error
        stop
        log error: error.inspect
        log debug: error.backtrace.join("\n")
        log info: "shutting down!"
      end
    end
  end
end
