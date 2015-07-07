module Router
  module Rest
    class Server
      extend Singleton
      include Logging
      include Registerable
      log_level Logger::INFO
      category :rest
      def server
        @server ||= WEBrick::HTTPServer.new(
          Port:   Router.options.rest.port,
          Logger: logger
        )
      end
      def start
        log debug: "Starting REST-Api"
        server.mount_proc "/services", api.services
        Thread.new { server.start }
      end
      def stop
        log debug: "Stopping REST-Api"
        server.shutdown
      end
      def api
        @api ||= Api.new
      end
    end
  end
end