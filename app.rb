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
EMPTY = ["m1","t1","w1","r1","s1"]

DAY = ["mon","tue","wed","thu","fri","sat","sun"]
TIME = (9..21).to_a

fetch1 = "m"
fetch2 = "1"
fecth = "m1"
text_day = "Monday"


#incoming_text_day?
def incoming_text_day? body
  DAY.each do |word|
    if body.include?(word)
      return true
    end
  end
  return false
end

#incoming_text_time?
def incoming_text_time? body
  TIME.each.to_s do |word|
    if body.include?(word)
      return true
    end
  end
  return false
end


get "/" do
	404
end


get "/sms/incoming" do
  session["last_intent"] ||= nil
  
  session["counter"] ||= 1
  session["count"] ||= 1
  
  count = session["counter"]  
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  if session["counter"] == 1
    message = "Thanks for your first message. From #{sender} saying #{body}."
    message = " I am a bot works in Tamordnual Laundromat. My name is LaundromatGo🤖 and I'd like to help you check whether it's busy or empty in our laundromat in the time period you specify"
    message = " Message me a day in a week like 'Mon' to begin your search"
    session["counter"] += 1
  else
    message = "Thank you #{sender} for reaching LaundromatGo🤖 again. Message me to begin your search"
  end
  
  # ask for day
  while   session["count"] == 1
    if incoming_text_day? body
      if /mon/ =~ body
       fetch1 = "m"
       text_day = "Monday"
      elsif /tue/ =~ body
       fetch1 = "t"
       text_day = "Tuesday"
      elsif /wed/ =~ body
       fetch1 = "w"
       text_day = "Wednesday"
      elsif /thu/ =~ body
       fetch1 = "r"
       text_day = "Thursday"
      elsif /fri/ =~ body
       fetch1 = "f"
       text_day = "Friday"
      elsif /sat/ =~ body
       fetch1 = "s"
       text_day = "Saturday"
      else
       fetch1 = "u"
       text_day = "Sunday"
      end
       message = "Great! Then, what time do you want to come on that day, please type intergals from 0 to 23 only"
       session["count"] += 1
       break
    else
     message = "I didn't catch that. please include the day 'Mon, Monday, etc.' in your question"
    end
  end 
  
  # ask for time
  while session["count"] == 2
    if incoming_text_time? body
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
    else
    message = "Our business hour is 9am to 10pm, so please consider type intergals from 9 to 21"
  end
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



