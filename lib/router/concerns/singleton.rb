module Router
  module Singleton
    def instance
      @instance ||= self.new
    end
    def method_missing method, *args, &block
      instance.send method, *args, &block
    end
  end
end