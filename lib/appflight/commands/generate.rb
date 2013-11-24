require 'fileutils'
require 'highline'

command :generate do |c|
  c.syntax = 'appflight generate [options]'
  c.summary = 'Generate a new web page'
  c.description = ''

  c.option '-d', '--destination DESTINATION', 'Destination. Defaults to current directory'
  c.option '-o', '--object IPA', 'Find .ipa file path. Defaults to current path'

  c.action do |arg, options|
    @h = HighLine.new
    @destination = options.destination || "flight"

    @files = generate_files()
    FileUtils.mkdir(@destination)
    puts "\t#{@h.color('create', :green)}"
    @files.each { |key, fd|
      File.open("#{key}", "w").write(File.read(fd))
      puts "\t#{@h.color('create', :green)}\t#{key}"
    }

    # Dotenv.load ".env.app"
    # @object = ENV['ipa_name'] || options.object
  end
end

private

def generate_files()
  files = []
# @page = AppFlight::Web::Page.new
  files << [".env.app", File.open("#{AppFlight::Utils.gem_webdir}/template/dot.env.app")]
  files << [".env.s3", File.open("#{AppFlight::Utils.gem_webdir}/template/dot.env.s3")]
  files << ["#{@destination}/1.jpg", File.open("#{AppFlight::Utils.gem_webdir}/template/1.jpg")]
  files << ["#{@destination}/style.css", File.open("#{AppFlight::Utils.gem_webdir}/template/style.css")]
  files << ["#{@destination}/index.html.erb", File.open("#{AppFlight::Utils.gem_webdir}/template/index.html.erb")]
  files << ["#{@destination}/plist.erb", File.open("#{AppFlight::Utils.gem_webdir}/template/plist.erb")]
#  files << ["index.html", StringIO.new(@page.render("template/index.html"))]
#  files << ["plist",      StringIO.new(@page.render("template/plist"))]
  files
end
