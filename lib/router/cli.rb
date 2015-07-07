require "router"

module Router
  class Cli < Thor
    default_task :start
    desc "start","Start Router"
    method_option :port, type: :array, default: Router.options.ports
    def start
      Router.start options:options
    end
    desc "link","place binstubs in target"
    def link target
      Router.link target,options:options
    end
  end
end