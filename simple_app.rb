# "LaundromatGo🤖" is a SMS bot for a laundromat, customers can check the whether the laundromat is crowded in the piece the day they specify. 
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
  
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  
  if session["counter"] == 1
    message = "Hi, I'm LaundromatGo🤖 and I can help you to check whether it will be crowded in our laundromat. Type the day you want to check like this 'Mon' "
    session["counter"] += 1
    if body == "mon" 
      message = "Great! There won't be too many people in our laundromat in Monday"
    elsif body == "tue"
      message = "Great! There won't be too many people in our laundromat in Tuesday"
    elsif body == "wed"
      message = "Great! There won't be too many people in our laundromat in Wednesday"
    elsif body = "thu"
      message = "Great! There won't be too many people in our laundromat in Thursday"
    elsif body = "fri"
      message = "Great! There won't be too many people in our laundromat in Friday"
    elsif body = "sat"      
      message = "Saturday will be very crowded and busy, you'd better choose another time."
    elsif body = "sat"      
      message = "Saturday will be very crowded and busy, you'd better choose another time."
    else
      message = "I didn't understand that. You can say mon, tue, wed, etc."
    end
  else
    message = "Welcome back, please tell me what day do you want to come to our laundromat like this 'Mon'"
    if body == "mon" 
      message = "Great! There won't be too many people in our laundromat in Monday"
    elsif body == "tue"
      message = "Great! There won't be too many people in our laundromat in Tuesday"
    elsif body == "wed"
      message = "Great! There won't be too many people in our laundromat in Wednesday"
    elsif body = "thu"
      message = "Great! There won't be too many people in our laundromat in Thursday"
    elsif body = "fri"
      message = "Great! There won't be too many people in our laundromat in Friday"
    elsif body = "sat"      
      message = "Saturday will be very crowded and busy, you'd better choose another time."
    elsif body = "sat"      
      message = "Saturday will be very crowded and busy, you'd better choose another time."
    else
      message = "I didn't understand that. You can say mon, tue, wed, etc."
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


