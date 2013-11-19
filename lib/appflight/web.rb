require 'erubis'
require_relative './utils'

module AppFlight
  module Web
    class Page
      def initialize
        @context = {}
      end

      def render(name)
        determine!
        template = "#{name}.erb"
        input = File.read("#{AppFlight::Utils.gem_webdir}/#{template}")
        eruby = Erubis::Eruby.new(input)
        eruby.result(@context)
      end

      private

      def determine!
        determine_ipaname!
        determine_bundleid!
        determine_appname!
        determine_appdesc!
        determine_getdomain!
      end

      def determine_ipaname!
        @context[:ipa_name] ||= ENV['ipa_name'] 
        @context[:ipa_name] ||= ask "IPA File Name:"
      end

      def determine_bundleid!
        @context[:bundle_id] ||= ENV['bundle_id'] 
        @context[:bundle_id] ||= ask "Bundle ID:"
      end

      def determine_appname!
        @context[:app_name] ||= ENV['app_name'] 
        @context[:app_name] ||= ask "App Name:"
      end

      def determine_appdesc!
        @context[:app_desc] ||= ENV['app_desc']
        @context[:app_desc] ||= ask "App Description:"
      end

      def determine_getdomain!
        @context[:get_domain] ||= ENV['get_domain']
        @context[:get_domain] ||= ask "Get DomainName:"
      end

    end
  end
end
