module Router
  module Eventable
    def callbacks
      @callbacks ||= {}
    end
    def on params={}
      callbacks[params.first.first.to_sym] = params.first.last
    end
  end
end