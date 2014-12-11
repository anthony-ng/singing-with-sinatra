require 'sinatra'
require 'data_mapper'
require 'time'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

SITE_TITLE = "To Do List"
SITE_DESCRIPTION = "My little ToDo list using Sinatra"

enable :sessions

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Note
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

##### Escpe all user-submitted content
helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

#
##### Application
#

get '/' do
    @notes = Note.all :order => :id.desc
    @title = 'All Notes'
    if @notes.empty?
        flash[:error] = 'No notes found. Add your first below.'
    end
    erb :home
end

##### Adding a Note to the Database
post '/' do
    n = Note.new
    n.content = params[:content]
    n.created_at = Time.now
    n.updated_at = Time.now
    if n.save
        redirect '/', :notice => 'Note created successfully.'
    else
        redirect '/', :error => 'Failed to save note.'
    end
end

##### RSS Feed

get '/rss.xml' do
	@notes = Note.all :order => :id.desc
	builder :rss
end

##### Editing a Note
get '/:id' do
    @note = Note.get params[:id]
    @title = "Edit note ##{params[:id]}"
    if @note
        erb :edit
    else
        redirect '/', :error => "Can't find that note."
    end
end

##### Using PUT for Editing
get '/:id/complete' do
    n = Note.get params[:id]
    unless n
        redirect '/', :error => "Can't find that note."
    end
    n.complete = n.complete ? 0 : 1 # flip it
    n.updated_at = Time.now
    if n.save
        redirect '/', :notice => 'Note marked as complete.'
    else
        redirect '/', :error => 'Error marking note as complete.'
    end
end

##### Deleting a Note
get '/:id/delete' do
    @note = Note.get params[:id]
    @title = "Confirm deletion of note ##{params[:id]}"
    if @note
        erb :edit
    else
        redirect '/', :error => "Can't find that note."
    end
end

##### Using DELETE for deleting
delete '/:id' do
    n = Note.get params[:id]
    if n.destroy
        redirect '/', :notice => 'Note deleted successfully.'
    else
        redirect '/', :error => 'Error deleting note.'
    end
end

##### Marking a Note as "Complete"
get '/:id/complete' do
  n = Note.get params[:id]
  n.complete = n.complete ? 0 : 1 # flip it
  n.updated_at = Time.now
  n.save
  redirect '/'
end


