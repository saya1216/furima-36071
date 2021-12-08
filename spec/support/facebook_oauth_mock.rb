module FacebookOauthMockHelper
  def facebook_oauth_mock
# テスト用にモックを使うための設定
# '/auth/provider'へのリクエストが、即座に'/auth/provider/callback'にリダイレクトされる
    OmniAuth.config.test_mode = true

# facebook用のモック
# '/auth/provider/callback'にリダイレクトされた時に渡されるデータを生成
    OmniAuth.config.mock_auth[:facebook]=
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '1234567',
        info: {
          email: 'joe_bloggs@example.com',
          name: 'Joe Bloggs',
          image: 'http://graph.facebook.com/1234567/picture?type=square'
        },
        credentials: {
          token: 'ABCDEF...',
          expires_at: 1321747205,
          expires: true
        },
        extra: {
          raw_info: {
            id: '1234567',
            name: 'Joe Bloggs',
            email: 'joe_bloggs@example.com'
          }
        }
      )
  end
end  