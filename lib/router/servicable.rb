module Router
  class Service
    include Eventable
    attr_writer :interval
    def interval
      @interval ||= 5
    end
  end
end