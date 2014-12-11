require 'sinatra'

###### The Very Basics (a 'Route')

get '/' do
  "Hello, World!"
end

get '/about' do
  'A little about me.'
end

###### Accessing URL Parameters

get '/hello/:name' do
  "Hello there, #{params[:name].upcase}"
end

get '/hello/:name/:city' do
  "Hey there #{params[:name].capitalize} from #{params[:city].upcase}."
end

get '/more/*' do
  params[:splat]
end

###### View Files & POST

get '/form' do
  erb :form
end

post '/form' do
  "You said '#{params[:message]}'"
end

###### Message encryptor

get '/secret' do
  erb :secret
end

post '/secret' do
  params[:secret].reverse
end

###### Decryptor directly on page
get '/decrypt/:secret' do
  params[:secret].reverse
end

# get '/*' do
#   status 404
#   'not found'
# end

not_found do
  halt 404, 'page not found!!'
end
