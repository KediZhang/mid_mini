# "LaundromatGo" is a SMS bot for a laundromat, customers can check the whether the laundromat is crowded in the piece the time they specify. Staff in the laundromat can also update the data base through SMS when popular hours of the laundromat has changed due to bad weather, broken machine, etc.
# Link: https://evening-escarpment-93924.herokuapp.com/
# Number: (412) 459 7528

require "sinatra"
require 'sinatra/reloader' if development?

require 'twilio-ruby'

enable :sessions

@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]



configure :development do
  require 'dotenv'
  Dotenv.load
end


get "/" do
	404
end


get "/sms/incoming" do
  session["last_intent"] ||= nil
  
  session["counter"] ||= 1
  count = session["counter"]  
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  if body == "who" and body.starts_with? "who"
    message = "I'm Daragh's MeBot"
  elsif body == "what"
      message = "I'm a bot that'll let you ask things about Daragh without bothering him."
  elsif body == "why"
    message = "He made me for this class. To show you how to make simple bots"
  elsif body = "where"
    message = "I'm on a server in the cloud.. But Daragh's in Pittsburgh"
  elsif body = "when"
    message = "I was made on Sept 14th. But Daragh is much older than that"
  else
    message = "I didn't understand that. You can say who, what, where, when and why?"
      
  end
  
  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message do |m|
      m.body( message )
      #unless media.nil?
       # m.media( media )
      #end
    end 
  end

  
  content_type 'text/xml'
  twiml.to_s
  
end