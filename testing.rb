# "LaundromatGo🤖" is a SMS bot for a laundromat, customers can check the whether the laundromat is crowded in the piece the time they specify. 
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


# I have simplified the status into two catergory "busy" and "empty". Time has also been simplified into only two period: day and night.
# Of course this data pool can be expended by dividing it into more catergories.

busy = "m2t2w2r2f1f2s2u1u2"

session['fetch1'] = "m"
session['fetch2'] = "1"
session['fecth'] = "m1"
session['text_day'] = "Monday"

get "/" do
	404
end



get "/sms/incoming" do
  session["last_intent"] ||= nil
  
  session["counter"] ||= 1
  session["counter2"] ||= 1
  
  count = session["counter"]  
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  if session["counter"] == 1
    message = "Thanks for your first message. From #{sender} saying #{body}. I am a bot called LaundromatGo🤖 and working in Tamordnual Laundromat. I'd like to help you check whether it's busy or empty in our laundromat in the time period you specify. Message me a day in a week like 'Monday' to begin your search"
    session["counter"] += 1
  else
    message = "Thank you #{sender} for reaching LaundromatGo🤖 again. Message me to begin your search"
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

