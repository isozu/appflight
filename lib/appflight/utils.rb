require_relative 'version'

module AppFlight
  module Utils
    def self.gem_webdir
      dirs = ["#{File.dirname(File.expand_path($0))}/../web",
              "#{Gem.dir}/gems/#{AppFlight::NAME}-#{AppFlight::VERSION}/web"]
      dirs.each {|path| return path if Dir.exists?(path) }
      raise "all paths are invalid: #{dirs}"
    end
  end
end
