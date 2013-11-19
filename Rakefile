require "bundler/setup"

gemspec = eval(File.read("appflight.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["appflight.gemspec"] do
  system "gem build appflight.gemspec"
end
