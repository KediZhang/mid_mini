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
     text_day = "Monday"
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
   
   elsif body.include?('tue')
     fetch1 = "t"
     text_day = "Tuesday"
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
     
   elsif body.include?('wed')
     fetch1 = "w"
     text_day = "Wednesday"
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
     
   elsif body.include?('thu')
     fetch1 = "r"
     text_day = "Thursday"
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
     
   elsif body.include?('fri')     
     fetch1 = "f"
     text_day = "Friday"
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
     
   elsif body.include?('sat')
     fetch1 = "s"
     text_day = "Saturday"
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
     
   elsif body.include?('sun')
     fetch1 = "n"
     text_day = "Sunday" 
     message = "You said #{text_day}. Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
     
   else
     message = "I didn't understand that. You can say Mon, Monday, Tue, etc."  
  end

 
  if body.to_i < 18
     session['fetch2'] = "1"
    else
     session['fetch2'] = "2"
  end
    
    fetch = session['fetch1']+session['fetch2']
  
  if busy.include? fetch
     message = "#{body} o'clock on #{text_day} will be very crowded and busy, you'd better choose another time."
    else
     message = "Great! There won't be too many people in our laundromat in #{body} o'clock on #{text_day}"
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

