module Router
  class Docker < Service
    class << self
      def url
        def gateway
          `ip -4 -o route | grep ^default | awk '{print $3}'`.strip
        end
        url ||= ENV["DOCKER_HOST"] if ENV["DOCKER_HOST"]
        url ||= "/var/run/docker.sock" if File.socket? "/var/run/docker.sock"
        url ||= "tcp://#{gateway}:2375"
      end
    end
    include Logging
    include Registerable

    attr_accessor :url

    def initialize url=nil
      @url   = url
      @url ||= self.class.url
      @category = :docker
      log debug: "Docker at #{@url}"
    end
    def id
      @id ||= Digest::MD5.hexdigest @url.to_s
    end
    def containers
    end
  end
end