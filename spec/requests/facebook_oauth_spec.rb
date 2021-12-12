require 'rails_helper'

RSpec.describe 'FacebookOauth', type: :request do
  include FacebookOauthMockHelper

  describe 'SNS認証' do
    before do
      OmniAuth.config.mock_auth[:facebook] = nil
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = facebook_oauth_mock
    end
    it 'APIにリクエストを送信すると正常にレスポンスが返ってくる' do
      username = ENV['BASIC_AUTH_USER']
      password = ENV['BASIC_AUTH_PASSWORD']
      post '/users/auth/facebook/callback', headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
      expect(response.status).to eq(200)
    end
  end
end
