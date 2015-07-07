module Router
  class Service
    attr_accessor :docker
    def initialize docker, id
      @docker = docker
      @id     = container.json["Id"]
    end
    def container
      ::Docker::Container.get(@id,{},@docker)
    end
  end
end