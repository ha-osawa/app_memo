# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

json_path = 'data/memo_data.json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @title = 'メモ一覧'
  @memos = File.open(json_path) { |file| JSON.parse(file.read) } unless File.empty?(json_path)
  erb :top
end

get '/memos/new' do
  @title = '新規作成'
  erb :new
end

post '/memos/new' do
  memos = []
  File.open(json_path) do |file|
    memos = JSON.parse(file.read) unless File.empty?(json_path)
    memos.push({ id: SecureRandom.uuid, title: params[:memo_title], content: params[:memo_content] })
  end

  File.open(json_path, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect '/memos'
end

get '/memos/:memo_id' do
  memos = File.open(json_path) { |file| JSON.parse(file.read) }
  @memo = memos.find { |memo| memo['id'] == params[:memo_id] }
  @title = 'メモの詳細'
  erb :show
end

delete '/memos/:memo_id' do
  memos = File.open(json_path) { |file| JSON.parse(file.read) }
  remain_memos = memos.delete_if { |memo| memo['id'] == params[:memo_id] }
  File.open(json_path, 'w') do |file|
    JSON.dump(remain_memos, file)
  end
  redirect '/memos'
end

get '/memos/:memo_id/edits' do
  @title = 'メモの編集'
  @memo_id = params[:memo_id]
  erb :edit
end

patch '/memos/:memo_id' do
  memos = File.open(json_path) { |file| JSON.parse(file.read) }
  memo_index = memos.find_index { |memo| memo['id'] == params[:memo_id] }
  memos[memo_index]['title'] = params[:memo_title] unless params[:memo_title].empty?
  memos[memo_index]['content'] = params[:memo_content] unless params[:memo_content].empty?
  File.open(json_path, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect '/memos'
end
