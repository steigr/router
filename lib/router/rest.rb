require "router/rest/api"
require "router/rest/server"

module Router
  module Rest
    def self.create
      Server.create
    end
  end
end