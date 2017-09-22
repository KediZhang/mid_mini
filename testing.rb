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

fetch1 = "m"
fetch2 = "1"
fecth = "m1"
text_day = nil
counter2 = 1

get "/" do
	404
end



get "/sms/incoming" do
  session["last_intent"] ||= nil
  
  session["counter"] ||= 1
  
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  if session["counter"] == 1
    message = "Thanks for your first message. From #{sender} saying #{body}. I am a bot called LaundromatGo🤖 and working in Tamordnual Laundromat. I'd like to help you check whether it's busy or empty in our laundromat in the time period you specify. Message me a day in a week like 'Monday' to begin your search"
    session["counter"] += 1
  else
    message = "Thank you #{sender} for reaching LaundromatGo🤖 again. Message me to begin your search"
  end
 
  if body.include?('mon')
     fetch1 = "m"
     counter2 += 1
     text_day = "Monday"
   elsif body.include?('tue')
     fetch1 = "t"
     counter2 += 1
     text_day = "Tuesday"
   elsif body.include?('wed')
     fetch1 = "w"
     counter2 += 1
     text_day = "Wednesday"
   elsif body.include?('thu')
     fetch1 = "r"
     counter2 += 1
     text_day = "Thursday"
   elsif body.include?('fri')
     fetch1 = "f"
     counter2 += 1
     text_day = "Friday"
   elsif body.include?('sat')
     fetch1 = "s"
     counter2 += 1
     text_day = "Saturday"
   elsif body.include?('sun')
     fetch1 = "n"
     counter2 += 1 
     text_day = "Sunday" 
   else
     message = "I didn't understand that. You can say Mon, Monday, Tue, etc."  
  end

 
 
 
  message = "Got it #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
  
 
 
 
 
    
  
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

