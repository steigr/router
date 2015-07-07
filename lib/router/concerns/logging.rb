require "colorize"

module Router
  module Logging
    module InstanceMethods
      def log params={}
        self.class.log params
      end
      def logger
        Router::Logging.logger_for self
      end
      def color
        @log_color ||= Router::Logging.color SecureRandom.hex(8)
      end
      def log_color color=nil
        self.class.log_color color
      end
      def log_level level
        self.class.log_level level
      end
      def log_prefix
        self.class.name
      end
    end
    module ClassMethods
      def log params={}
        logger.send params.first.first, params.first.last
      end
      def logger
        Router::Logging.logger_for self
      end
      def color
        @log_color ||= Router::Logging.color SecureRandom.hex(8)
      end
      def log_color log_color=nil
        @log_color ||= log_color
        @log_color ||= :black
      end
      def log_level log_level=nil
        logger.level = ( @log_level || Logger::DEBUG )
      end
      def log_prefix
        self.name
      end
    end
    def self.included base
      base.send :include, Router::Logging::InstanceMethods
      base.send :extend, Router::Logging::ClassMethods
    end
    class << self
      def loggers
        @loggers ||= {}
      end
      def logger_for object
        loggers[object.object_id] ||= build_logger(object)
      end
      def build_logger object
        logger = Logger.new(Router.options.log_file)
        logger.formatter = build_formatter(object)
        logger
      end
      def build_formatter object
        color  = object.color
        prefix = object.log_prefix
        Proc.new do |severity, datetime, progname, msg|
         "#{severity.ljust(5," ").red} #{prefix.ljust(26," ").colorize(color).underline} #{msg.to_s}\n"
        end
      end
      def color key
        colors[key] ||= next_color
      end
      def colors
        @colors ||= {}
      end
      def next_color
        @log_colors ||=  String.colors.reject{|x|x=~/(white|light)/}
        @size       ||= @log_colors.size
        @key          = (@key%@size)+1 rescue 0
        @log_colors[@key]
      end
    end
  end
end