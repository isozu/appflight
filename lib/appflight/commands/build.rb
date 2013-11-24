require 'fileutils'

command :build do |c|
  c.syntax = 'appflight build [options]'
  c.summary = 'Build a new .ipa file'
  c.description = ''

  c.action do |arg, options|
    @provision ||= ENV['provision'] 
    @provision ||= ask "Mobile Provision:"

    @configure ||= ENV['configure'] 
    @configure ||= ask "Configuration:"

    build_file
  end
end

private

def build_file
  system %{ipa build --clean --destination . --configuration #{@configure} -m "#{@provision}"}
end
