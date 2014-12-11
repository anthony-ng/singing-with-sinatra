require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Note
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end


get '/' do
  @notes = Note.all :order => :id.desc
  @title = 'All Notes'
  erb :home
end

##### Adding a Note to the Database
post '/' do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end

##### Editing a Note
get '/:id' do
  @note = Note.get params[:id]
  @title = "Edit note ##{params[:id]}"
  erb :edit
end

##### Using PUT for Editing
put '/:id' do
  n = Note.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.save
  redirect '/'
end

##### Deleting a Note
get '/:id/delete' do
  @note = Note.get params[:id]
  @title = "Confirm deletion of ntoe ##{params[:id]}"
  erb :delete
end

DataMapper.finalize.auto_upgrade!
