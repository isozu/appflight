require 'aws-sdk'
require_relative '../utils'

module AppFlight::Plugins
  module S3
    class Client
      def initialize(access_key_id, secret_access_key, region)
        @s3 = AWS::S3.new(:access_key_id => access_key_id,
                          :secret_access_key => secret_access_key,
                          :region => region)
      end

      def upload_files(files = [], options)
        @s3.buckets.create(options[:bucket]) if options[:create]
        @bucket = @s3.buckets[options[:bucket]]

        @page = AppFlight::Web::Page.new
        files << ["style.css",  File.open("#{AppFlight::Utils.gem_webdir}/style.css")]
        files << ["index.html", StringIO.new(@page.render("index.html"))]
        files << ["plist",      StringIO.new(@page.render("plist"))]
        files.each do |key, fd|
          upload(key, fd)
        end
      end

      def upload_ipa(options)
        @s3.buckets.create(options[:bucket]) if options[:create]
        @bucket = @s3.buckets[options[:bucket]]
        @ipa_name = ENV['ipa_name'] 
        @ipa_name ||= ask "IPA File Name:"
        File.open("./#{@ipa_name}") { |fd|
          upload(@ipa_name, fd)
        }
      end

      def upload(key, fd)
        begin
          @bucket.objects.create(key, fd, :acl => 'public_read')
          say_ok "Successfully uploaded #{key} to S3."
        rescue => exception
          say_error "Error while uploading to S3: #{exception}"
        end
      end
    end
  end
end

command :'release:s3' do |c|
  c.syntax = "appflight release:s3 [options]"
  c.summary = "Release an iOS app file over Amazon S3"
  c.description = ""

  c.example '', '$ appflight release:s3 -f ./file.ipa -a accesskeyid --bucket bucket-name'

  c.option '-f', '--file FILE', ".ipa file for the build"
  c.option '-a', '--access-key-id ACCESS_KEY_ID', "AWS Access Key ID"
  c.option '-s', '--secret-access-key SECRET_ACCESS_KEY', "AWS Secret Access Key"
  c.option '-b', '--bucket BUCKET', "S3 bucket"
  c.option '-r', '--region REGION', "Optional AWS region"

  c.action do |args, options|

    @access_key_id = options.access_key_id
    determine_access_key_id! unless @access_key_id = options.access_key_id
    say_error "Missing AWS Access Key ID" and abort unless @access_key_id

    @secret_access_key = options.secret_access_key
    determine_secret_access_key! unless @secret_access_key = options.secret_access_key
    say_error "Missing AWS Secret Access Key" and abort unless @secret_access_key

    @bucket = options.bucket
    determine_bucket! unless @bucket = options.bucket
    say_error "Missing bucket" and abort unless @bucket

    @region = options.region
    determine_region! unless @region = options.region
    say_error "Missing region" and abort unless @region

    client = AppFlight::Plugins::S3::Client.new(@access_key_id, @secret_access_key, @region)
    client.upload_files({:bucket => @bucket, :create => !!options.create})
    puts "Uploading .ipa file. Taking a few minutes..."
    client.upload_ipa({:bucket => @bucket, :create => !!options.create})
  end

  private

  def determine_access_key_id!
    @access_key_id ||= ENV['AWS_ACCESS_KEY_ID']
    @access_key_id ||= ask "Access Key ID:"
  end

  def determine_secret_access_key!
    @secret_access_key ||= ENV['AWS_SECRET_ACCESS_KEY']
    @secret_access_key ||= ask "Secret Access Key:"
  end

  def determine_bucket!
    @bucket ||= ENV['S3_BUCKET']
    @bucket ||= ask "S3 Bucket:"
  end

  def determine_region!
    @region ||= ENV['AWS_REGION'] || ""
  end
end
