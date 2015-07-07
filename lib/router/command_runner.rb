module Router
  module CommandRunner
    def run cmd
      Open3.popen3(cmd) do |stdin,stdout,stderr,thread|
        Thread.new do
          begin
            while(line=stdout.gets) do
              log debug: line
            end
          rescue IOError
            nil
          end
        end
        Thread.new do
          begin
            while(line=stderr.gets) do
              log error: line
            end
          rescue IOError
            nil
          end
        end
        thread.join
        return thread.value
      end
    end
  end
end
