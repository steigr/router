module Router
  module Checkable
    attr_writer :interval
    def interval
      @interval ||= 5
    end
  end
end