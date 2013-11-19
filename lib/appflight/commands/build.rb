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

    system %{ipa build --clean --destination . --configuration #{@configure} -m "#{@provision}"}
  end
end

private

def build_file
end
