require 'aws-sdk'
require 'fileutils'
require_relative '../utils'

Dotenv.load ".env.s3"

module AppFlight::Plugins
  module S3
    class Client
      def initialize(access_key_id, secret_access_key, region)
        @s3 = AWS::S3.new(:access_key_id => access_key_id,
                          :secret_access_key => secret_access_key,
                          :region => region)
        @h = HighLine.new
      end

      def prepare_buckets(options)
        @s3.buckets.create(options[:bucket]) if options[:create]
        @bucket = @s3.buckets[options[:bucket]]
      end

      def upload_files(files = [], options)
        prepare_buckets(options)
        puts "\t#{@h.color('upload', :green)}\tto S3"
        @page = AppFlight::Web::Page.new
        Dir.glob("#{options[:destination]}/*") { |file|
          if file.match('.erb$') then
            upload(File.basename(file).gsub(".erb",""), 
                   StringIO.new(@page.render(file)))
          else
            upload(File.basename(file), File.open(file))
          end
        }
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
          puts "\t#{@h.color('upload', :green)}\t#{key}"
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
  c.option '-d', '--destination DESTINATION', 'Destination. Defaults to the "flight" directory'

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

    @destination = options.destination || "flight"

    client = AppFlight::Plugins::S3::Client.new(@access_key_id, @secret_access_key, @region)
    client.upload_files({:bucket => @bucket, :create => !!options.create, :destination => @destination})
    puts "Uploading .ipa file. Taking a few minutes..."
    client.upload_ipa({:bucket => @bucket, :create => !!options.create, :destination => @destination})
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
