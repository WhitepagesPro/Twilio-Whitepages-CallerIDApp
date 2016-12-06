require 'net/http'
require 'net/https'
require 'builder'
require 'cgi'
require 'openssl'
require 'base64'
require 'forwardable'
require 'jwt'

require 'twilio-ruby-sync/version' unless defined?(Twilio::VERSION)
require 'rack/twilio_webhook_authentication'

require 'twilio-ruby-sync/util'
require 'twilio-ruby-sync/util/capability'
require 'twilio-ruby-sync/util/client_config'
require 'twilio-ruby-sync/util/configuration'
require 'twilio-ruby-sync/util/request_validator'
require 'twilio-ruby-sync/util/access_token'
require 'twilio-ruby-sync/twiml/response'

Dir[File.dirname(__FILE__) + "/twilio-ruby-sync/http/**/*.rb"].each do |file|
  require file
end
Dir[File.dirname(__FILE__) + "/twilio-ruby-sync/framework/**/*.rb"].each do |file|
  require file
end
Dir[File.dirname(__FILE__) + "/twilio-ruby-sync/rest/*.rb"].each do |file|
  require file
end
Dir[File.dirname(__FILE__) + "/twilio-ruby-sync/rest/**/*.rb"].each do |file|
  require file
end
Dir[File.dirname(__FILE__) + "/twilio-ruby-sync/compatibility/**/*.rb"].each do |file|
  require file
end
Dir[File.dirname(__FILE__) + "/twilio-ruby-sync/task_router/**/*.rb"].each do |file|
  require file
end


module Twilio
  extend SingleForwardable

  def_delegators :configuration, :account_sid, :auth_token

  ##
  # Pre-configure with account SID and auth token so that you don't need to
  # pass them to various initializers each time.
  def self.configure(&block)
    yield configuration
  end

  ##
  # Returns an existing or instantiates a new configuration object.
  def self.configuration
    @configuration ||= Util::Configuration.new
  end
  private_class_method :configuration
end
