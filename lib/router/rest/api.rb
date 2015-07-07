module Router
  module Rest
    class Api
      include Logging
      def services
        proc do |req,res|
          log info: req.path
          res.header["Content-Type"] = "application/json"
          res.body = Registry.category("services").to_json
        end
      end
    end
  end
end