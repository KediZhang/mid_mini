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

BUSY = ["m2","t2","w2","r2","f1","f2","s2","u1","u2"]

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
 
  while session["counter2"] == 1
   if body.include?('mon')
     session['fetch1'] = "m"
     session["counter2"] += 1
     break
   elsif body.include?('tue')
     session['fetch1'] = "t"
     session["counter2"] += 1
     break
   elsif body.include?('wed')
     session['fetch1'] = "w"
     session["counter2"] += 1
     break
   elsif body.include?('thu')
     session['fetch1'] = "r"
     session["counter2"] += 1
     break
   elsif body.include?('fri')
     session['fetch1'] = "f"
     session["counter2"] += 1
     break
   elsif body.include?('sat')
     session['fetch1'] = "s"
     session["counter2"] += 1
     break
   elsif body.include?('sun')
     session['fetch1'] = "n"
     session["counter2"] += 1  
     break
   else
     message = "I didn't understand that. You can say Mon, Monday, Tue, etc."  
   end
  end
 
 
 
 
 
 
  message = "Great! Then, what time do you want to come on that day? Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
  
  while session["counter2"] == 2
    if body.to_i < 18
     fetch2 = "1"
    else
     fetch2 = "2"
    end
    fetch = fetch1+fetch2
    if BUSY.include? fetch
     message = body + " o'clock on " + text_day + " will be very crowded and busy, you'd better choose another time."
    else
     message = "Great! There won't be too many people in our laundromat in " + body + " o'clock on " + text_day
    end
    session["count"] += 1
    break
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



