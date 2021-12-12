require 'rails_helper'

RSpec.describe 'Items', type: :request do
  
  before do
    @item = FactoryBot.create(:item)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get root_path, headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.status).to eq 200
    end
    it 'indexアクションにリクエストするとレスポンスに出品済みの商品の商品名・配送料の負担・値段が存在する' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get root_path, headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.body).to include(@item.item_name)
      expect(response.body).to include(@item.shipping_cost.name)
      expect(response.body).to include(@item.price.to_s)
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get root_path, headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.body).to include('test_image.png')
    end
    it 'indexアクションにリクエストするとレスポンスに出品ページへのリンクが存在する' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get root_path, headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.body).to include('出品する')
    end
    it 'indexアクションにリクエストするとレスポンスに投稿検索フォームが存在する' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get root_path, headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.body).to include('キーワードから探す')
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get item_path(@item), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに出品済みの商品の情報が存在する' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get item_path(@item), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.body).to include(@item.item_name)
      expect(response.body).to include(@item.information)
      expect(response.body).to include(@item.category.name)
      expect(response.body).to include(@item.sales_status.name)
      expect(response.body).to include(@item.shipping_cost.name)
      expect(response.body).to include(@item.prefecture.name)
      expect(response.body).to include(@item.shipping_days.name)
      expect(response.body).to include(@item.price.to_s)
    end
    it 'showアクションにリクエストするとレスポンスに出品済みの商品の画像URLが存在する' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      get root_path, headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.body).to include('test_image.png')
    end
  end
end
