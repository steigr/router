module Router
  module Checkable
    module ClassMethods
      def check interval, &block
        Thread.new do
          loop do
            sleep interval
            Thread.new do
              block.call
            end
          end
        end
      end
    end
    def self.included base
      base.send :extend, Router::Checkable::ClassMethods
    end
  end
end