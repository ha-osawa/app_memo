# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require_relative 'data/memo'

memo_obj = Memo.new
memo_obj.connect

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos = []
  @title = 'メモ一覧'
  @memos = memo_obj.read_all.values
  erb :top
end

get '/memos/new' do
  @title = '新規作成'
  erb :new
end

post '/memos' do
  memo_obj.write_memo(SecureRandom.uuid, params[:memo_title], params[:memo_content])
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo = memo_obj.read_memo(params[:memo_id]).values
  @title = 'メモの詳細'
  erb :show
end

delete '/memos/:memo_id' do
  memo_obj.delete_memo(params[:memo_id])
  redirect '/memos'
end

get '/memos/:memo_id/edit' do
  @title = 'メモの編集'
  @memo = memo_obj.read_memo(params[:memo_id]).values
  erb :edit
end

patch '/memos/:memo_id' do
  _, memo_title, memo_content = memo_obj.read_memo(params[:memo_id]).values.flatten
  memo_title = params[:memo_title] unless params[:memo_title].empty?
  memo_content = params[:memo_content] unless params[:memo_content].empty?
  memo_obj.update_memo(params[:memo_id], memo_title, memo_content)
  redirect '/memos'
end
