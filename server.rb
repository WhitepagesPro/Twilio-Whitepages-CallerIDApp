require_relative 'twilio-ruby-sync/lib/twilio-ruby-sync.rb'
require 'sinatra'
require 'sinatra/json'
require 'twilio-ruby'
require 'json'

disable :protection

# put your default Twilio Client name here, for when a phone number isn't given
default_client = "hales"
# Add a Twilio phone number or number verified with Twilio as the caller ID
caller_id   = ENV['twilio_caller_id']
account_sid = ENV['twilio_account_sid']
auth_token  = ENV['twilio_auth_token']
appsid      = ENV['twilio_app_id']
api_key     = ENV['twilio_api_key']
api_secret  = ENV['twilio_api_secret']
sync_sid    = ENV['twilio_sync_service_sid']
wSpace_sid  = ENV['twilio_workspace_sid']
wFlow_sid   = ENV['twilio_workflow_sid']

trClient = Twilio::REST::TaskRouterClient.new(account_sid, auth_token, wSpace_sid)

get '/' do
    client_name = params[:client]
    if client_name.nil?
        client_name = default_client
    end
    capability = Twilio::Util::Capability.new account_sid, auth_token
    # Create an application sid at twilio.com/user/account/apps and use it here/above
    capability.allow_client_outgoing appsid
    capability.allow_client_incoming client_name
    token = capability.generate
    erb :index, :locals => {:token => token, :client_name => client_name, :caller_id=> caller_id}
end

# Generate a token for use in our app
get '/token' do
  # Get the user-provided ID for the connecting device
  device_id = params['device']
  # Create a random username for the client
  identity = 'twilioTest'
  # Create a unique ID for the currently connecting device
  endpoint_id = "TwilioDemoApp:#{identity}:#{device_id}"
  # Create an Access Token for the app
  token = Twilio::Util::AccessToken.new account_sid, api_key, api_secret, 3600, identity
  token.identity = identity
  # Create app grant for out token
  grant = Twilio::Util::AccessToken::SyncGrant.new
  grant.service_sid = sync_sid
  grant.endpoint_id = endpoint_id
  token.add_grant grant
  # Generate the token and send to the client
  json :identity => identity, :token => token.to_jwt
end

#this will be called from a Twilio voice URL
#for inbound calls, dial the default_client
post '/inbound' do
    from = params[:From]
    addOnData = params[:AddOns]
    puts addOnData
    spamScore = results.whitepages_pro_phone_rep.result.results[0].reputation.level
    puts spamScore
    #if spamScore == 1
    #  task = trClient.workspace.tasks.create(workflow_sid: wFlow_sid, attributes: '{"SPAM":"1"}')
  #  trClient.
    client = Twilio::REST::Client.new(account_sid, auth_token)
    # Sending the add on data through Twilio Sync
    service = client.preview.sync.services(sync_sid)
    service.documents("TwilioChannel").update(data: addOnData)
    # Dials the default_client
    response = Twilio::TwiML::Response.new do |r|
        # Should be your Twilio Number or a verified Caller ID
        r.Dial :callerId => from do |d|
            d.Client default_client
        end
    end
    response.text
end
