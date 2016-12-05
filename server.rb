require 'twilio-ruby'
require 'sinatra'
require 'sinatra/json'
require 'json'

disable :protection

# put your default Twilio Client name here, for when a phone number isn't given
default_client = "hales"
# Add a Twilio phone number or number verified with Twilio as the caller ID
caller_id   = '(844) 700-9029'#ENV['twilio_caller_id']
account_sid = 'AC3568011c5b1ea77994ed50387219eb8e'#ENV['twilio_account_sid']
auth_token  = '7e3416e57e8aa7437e8f192d8c822ee0'#ENV['twilio_auth_token']
appsid      = 'APcb1860769148402be75b173806b777dd'#ENV['twilio_app_id']
api_key     = 'SKa0c7ce2321b4e3467cb129a7eab38811'#ENV['twilio_api_key']
api_secret  = 'ZIzHrvS6VRQpBw80RfabYXoYxT4SukUE'#ENV['twilio_api_secret']
sync_sid    = 'IS29396a29519d9672cb5e6e008d33ba0a'#ENV['twilio_sync_service_sid']
wSpace_sid  = 'WScb126ca61c237bd28dfd435a1ffc9666'#ENV['twilio_workspace_sid']
wFlow_sid   = 'WWb84571203d4560d9deef6c54d6498c22'#ENV['twilio_workflow_sid']

set :port, 8080

client = Twilio::REST::TaskRouterClient.new account_sid, auth_token, wSpace_sid

post '/assignment_callback' do
  # Responds to the assignment callbacks with
  content_type :json
  {}.to_json
end

get '/accept-reservation' do
  # Accept a Reservation
  task_sid = params[:task_sid]
  reservation_sid = param[:reservation_sid]

  reservation = client.workspace.tasks.get(task_sid).reservation.get(reservation_sid)
  reservation.update(reservationStatus: 'accepted')
  reservation.worker_name
end

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
    task = client.workspace.task.create(workflow_sid: wFlow_sid, from: from)

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
