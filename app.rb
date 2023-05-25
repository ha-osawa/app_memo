# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

json_path = 'public/memo_data.json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  @title = 'Top'
  @css_link = '/css/top.css'
  @memos =  File.open(json_path) { |file| JSON.parse(file.read) } unless File.empty?(json_path)
  erb :top
end

get '/memo/new' do
  @title = 'New memo'
  @css_link = '/css/edit_and_new.css'
  erb :new
end

post '/memo/new' do
  memo_hash = []
  File.open(json_path, 'a+') do |file|
    memo_hash = JSON.parse(file.read) unless File.empty?(json_path)
    memo_hash.push({ "id": SecureRandom.uuid, "title": h(params[:memo_title]), "content": h(params[:memo_content]) })
  end

  File.open(json_path, 'w+') do |file|
    JSON.dump(memo_hash, file)
  end
  redirect '/'
end

get '/memo/:memo_id' do
  memos = File.open(json_path) { |file| JSON.parse(file.read) }
  @memo = memos.find { |memo| memo['id'].include?(h(params[:memo_id])) }
  @title = 'Show memo'
  @css_link = '/css/show.css'
  erb :show
end

delete '/memo/:memo_id' do
  memos = File.open(json_path) { |file| JSON.parse(file.read) }
  remain_memo = memos.delete_if { |memo| memo['id'].include?(h(params[:memo_id])) }
  File.open(json_path, 'w') do |file|
    JSON.dump(remain_memo, file)
  end
  redirect '/'
end

get '/memo/:memo_id/edit' do
  @title = 'Edit memo'
  @memo_id = h(params[:memo_id])
  @css_link = '/css/edit_and_new.css'
  erb :edit
end

patch '/memo/:memo_id' do
  memos = File.open(json_path) { |file| JSON.parse(file.read) }
  memo_index = memos.find_index { |memo| memo['id'].include?(h(params[:memo_id])) }
  memos[memo_index]['title'] = h(params[:memo_title]) unless h(params[:memo_title]).empty?
  memos[memo_index]['content'] = h(params[:memo_content]) unless h(params[:memo_content]).empty?
  File.open(json_path, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect "/memo/#{h(params[:memo_id])}"
end
