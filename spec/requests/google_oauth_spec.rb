require 'rails_helper'

RSpec.describe 'GoogleOauth', type: :request do
  include GoogleOauthMockHelper

  describe 'SNS認証' do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = google_oauth_mock
    end
    it 'APIにリクエストを送信すると正常にレスポンスが返ってくる' do
      post '/users/auth/google_oauth2/callback'
      expect(response.status).to eq(200)
    end
  end
end
