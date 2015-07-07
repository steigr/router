module Router
  class Timer
    extend Singleton
    def initialize
      timer
    end
    def start
      timer.start
    end
    def stop
      timer.stop
    end
    def emit
      Thread.new{ Events.tick }
    end
    def timer
      @timer ||= Thread.new do
        Thread.stop
        loop do
          emit :tick
          sleep 1
        end
      end
    end
  end
end