module Router
  class Nginx
    extend  Singleton
    include Logging
    include Registerable
    include CommandRunner
    def update
      is_running ? reload : start
    end
    def _daemon
      @_daemon ||= `which nginx`.strip
    end
    def daemon
      [_daemon,"-c",config_file].join(" ")
    end
    def pid_file
      @pid_file ||= `#{_daemon} -V 2>&1`.scan(/--pid-path=([a-zA-Z0-9\.\/]+) /).flatten.last
    end
    def config_file
      @config_file ||= `#{_daemon} -V 2>&1`.scan(/--conf-path=([a-zA-Z0-9\.\/]+) /).flatten.last
    end
    def pid_of
      `pidof #{File.basename(_daemon)}`.strip
    end
    def is_running
      pid_of != 0
    end
    def stop
      status = run "#{daemon} -s quit"
      log info:  "#{__method__}: #{status.exitstatus}"
      status.exitstatus
    end
    def start
      status = run daemon
      log info:  "#{__method__}: #{status.exitstatus}"
      status.exitstatus
    end
    def reload
      if is_running
        if run("#{daemon} -s reload") != 0
          stop; start
        end
      else
        start
      end
    end
  end
end