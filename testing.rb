# "LaundromatGo🤖" is a SMS bot for a laundromat, customers can check the whether the laundromat is crowded in the piece the time they specify. 
# Link: https://evening-escarpment-93924.herokuapp.com/
# Number: (412) 459 7528

require "sinatra"
require 'sinatra/reloader' if development?

require 'twilio-ruby'

enable :sessions


# I have simplified the status into two catergory "busy" and "empty". Time has also been simplified into only two period: day and night.
# Of course this data pool can be expended by dividing it into more catergories.

DAY = ["mon","tue","wed","thu","fri","sat","sun"]


#incoming_text_day?
def incoming_text_day? body
  DAY.each do |x|
    if body.include?('x')
      return true
    end
  end
  return false
end



get "/" do
	404
end


get "/sms/incoming/:body" do
  
  session["count"] ||= 1
    
  body = params[:body] || ""
  body = body.downcase.strip
  # ask for day
  while   session["count"] == 1
    if incoming_text_day? body
       "Great! Then, what time do you want to come on that day, please type intergals from 0 to 23 only"
       session["count"] += 1
       break
    else
     "I didn't catch that. please include the day 'Mon, Monday, etc.' in your question"
    end
  end 
  
  
  #twiml = Twilio::TwiML::MessagingResponse.new do |r|
   # r.message do |m|
    #  m.body( message )
     
    #end 
    #end

  
 # content_type 'text/xml'
 #twiml.to_s
  
  
end

