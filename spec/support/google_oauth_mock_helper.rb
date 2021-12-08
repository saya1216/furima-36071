module GoogleOauthMockHelper
  def google_oauth_mock
# テスト用にモックを使うための設定
# '/auth/provider'へのリクエストが、即座に'/auth/provider/callback'にリダイレクトされる
    OmniAuth.config.test_mode = true

# google用のモック
# '/auth/provider/callback'にリダイレクトされた時に渡されるデータを生成
    OmniAuth.config.mock_auth[:google_oauth2]=
      OmniAuth::AuthHash.new(
        :provider => "google_oauth2",
        :uid => "123456789",
        :info => {
          :name => "John Doe",
          :email => "john.doe@example.com",
          :image => "https://lh3.googleusercontent.com/url/photo.jpg"
        },
        :credentials => {
          :token => "token",
          :expires_at => 1354920555,
          :expires => true
        },
        :extra => {
          :raw_info => {
            :email => "john.doe@example.com",
            :name => "John Doe",
          }
        }
      )
  end
end

# Facebook用のモック
# '/auth/provider/callback'にリダイレクトされた時に渡されるデータを生成

