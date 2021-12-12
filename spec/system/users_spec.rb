require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # basic_passのメソッドを実行
      basic_pass root_path
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: @user.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      fill_in 'last-name', with: @user.last_name
      fill_in 'first-name', with: @user.first_name
      fill_in 'last-name-kana', with: @user.last_name_kana
      fill_in 'first-name-kana', with: @user.first_name_kana
      find('#user_birthday_1i').find("option[value='1930']").select_option
      find('#user_birthday_2i').find("option[value='1']").select_option
      find('#user_birthday_3i').find("option[value='1']").select_option
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ニックネームにカーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.lists-right').find('.my-lists').hover
      ).to have_content('ログアウト')
      # ニックネームにカーソルを合わせると退会ボタンが表示されることを確認する
      expect(
        find('.lists-right').find('.my-lists').hover
      ).to have_content('退会')
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: ''
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      fill_in 'password-confirmation', with: ''
      fill_in 'last-name', with: ''
      fill_in 'first-name', with: ''
      fill_in 'last-name-kana', with: ''
      fill_in 'first-name-kana', with: ''
      find('#user_birthday_1i').find("option[value='']").select_option
      find('#user_birthday_2i').find("option[value='']").select_option
      find('#user_birthday_3i').find("option[value='']").select_option
      # 新規登録ボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq(user_registration_path)
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.lists-right').find('.my-lists').hover
      ).to have_content('ログアウト')
      # 新規登録ボタンやログインボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログアウトができるとき' do
    it 'ログアウトボタンをクリックするとログアウトできる' do
      # ログインする
      sign_in(@user)
      # ニックネームにカーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.lists-right').find('.my-lists').hover
      ).to have_content('ログアウト')
      # 「ログアウト」をクリックするとログアウトする
      click_on('ログアウト')
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # 新規登録ボタンやログインボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end
  end
end

RSpec.describe '退会', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
    user = FactoryBot.create(:user)
    @order_address = FactoryBot.build(:order_address, user_id: user.id)
  end
  context '退会ができるとき' do
    it '退会ボタンをクリックすると退会でき、出品した商品や自分以外の商品を購入した記録も消える' do
      # 商品２を出品したユーザーでログインする
      sign_in(@item2.user)
      # ユーザー1が出品した商品1の詳細画面に遷移する
      visit item_path(@item1)
      # 商品1の購入画面に遷移する
      visit item_orders_path(@item1)
      # 商品1を購入するためフォームに情報を入力する
      fill_in 'card-number', with: '4242424242424242'
      fill_in 'card-exp-month', with: '12'
      fill_in 'card-exp-year', with: '24'
      fill_in 'card-cvc', with: '123'
      fill_in 'postal-code', with: '123-4567'
      select '北海道', from: 'prefecture'
      fill_in 'city', with: '横浜市緑区'
      fill_in 'addresses', with: '青山1-1-1'
      fill_in 'phone-number', with: '09012345678'
      # 送信するとOrderモデルのカウントが１上がることを確認する
      expect do
        find('input[name="commit"]').click
        sleep 1.5
      end.to change { Order.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # 購入した商品1に「Sold Out!!」の文字があることを確認する
      expect(page).to have_content('Sold Out!!')
      # ニックネームにカーソルを合わせると退会ボタンが表示されることを確認する
      expect(
        find('.lists-right').find('.my-lists').hover
      ).to have_content('退会')
      # 退会ボタンを押す
      click_on('退会')
      # confirmのOKボタンをクリックすると退会できる
      expect do
        expect(page.accept_confirm).to eq '本当に退会しますか？'
        expect(page).to have_content 'ありがとうございました。またのご利用を心よりお待ちしております。'
      end.to change { User.count }.by(-1).and change { Item.count }.by(-1).and change { Order.count }.by(-1).and change {
                                                                                                                   Address.count
                                                                                                                 }.by(-1)
      # トップページの商品一覧に出品した商品が無いことを確認する
      expect(page).to have_no_content('@item2')
      # 購入した商品の画像が無いことを確認する
      expect(page).to have_no_content('@item1')
    end
  end
end
