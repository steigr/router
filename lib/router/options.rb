module Router
  def self.options
    @options ||= OpenStruct.new(
      ports: [22,25,80,143,443,587],
      rest:  URI("http://0.0.0.0:32489"),
      log_file: STDOUT
    )
  end
end