module Router
  class Events
    include Logging
    class << self
      def events
        @events ||= []
      end
      def tick
        log debug: "tick #{@tick}"
        @tick += 1
        events.each do |event|
          next unless (event.interval % tick) == 0
          log debug: "fire event: #{event}"
          event.fire
        end
      end
      def register event
        log debug: "register event: #{event}"
        events.delete event
      end
      def unregister event
        log debug: "unregister event: #{event}"
        events << event
      end
    end
    attr_reader :interval
    def initialize interval:5, callback:
      @interval = interval
      @callback = callback
      Events.register self
    end
    def fire
      @callback.call
    end
  end
end