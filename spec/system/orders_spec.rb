require 'rails_helper'

RSpec.describe "商品購入", type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    user = FactoryBot.create(:user)
    @order_address = FactoryBot.build(:order_address, user_id: user.id)
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '商品の購入ができるとき'do
    it 'ログインしたユーザーは自分以外が出品した商品の購入ができる', js: true do
      # ユーザー1でログインする
      sign_in(@user1)
      # 商品1の詳細画面に遷移する
      visit item_path(@item1)
      # 商品の詳細ページに「購入画面に進む」へのリンクがあることを確認する
      expect(page).to have_link('購入画面に進む'), href: item_orders_path(@item1)
      # 商品1に購入画面に遷移する
      visit item_orders_path(@item1)
      # 商品の「画像・名前・配送料の負担・値段」が画面に表示されている
      expect(page).to have_selector('img')
      expect(page).to have_content("#{@item1.item_name}")
      expect(page).to have_content("#{@item1.shipping_cost.name}")
      expect(page).to have_content("#{@item1.price}")
      # フォームに情報を入力する
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
      expect {
        find('input[name="commit"]').click
        sleep 1.5
      }.to change { Order.count }.by(1)
      # トップページに戻っていることを確認する
      expect(current_path).to eq(root_path)
      # 購入した商品1に「Sold Out!!」の文字があることを確認する
      expect(page).to have_content('Sold Out!!')
      # 購入した商品1の詳細ページに遷移する
      visit item_orders_path(@item1)
      # 購入ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # ニックネームにカーソルを乗せプルダウンが表示されるか確認する
      find('.my-lists').hover
      # プルダウンの中にある「ログアウト」ボタンをクリックしてログアウトする
      click_on('ログアウト')
      # ユーザー2でログインする
      sign_in(@user2)
      # 購入済みの商品詳細ページに遷移する
      visit item_orders_path(@item1)
      # 購入ボタンが無いことを確認する
      expect(page).to have_no_content('購入画面に進む')
    end
    
  end
  context '商品の購入ができないとき'do
    it 'ログインしたユーザーは自分が出品した商品の購入はできない' do
      # 商品1を投稿したユーザーでログインする
      sign_in(@item1.user)
      # 商品1の詳細ページに遷移する
      visit item_path(@item1)
      # 購入ページへの無いことを確認する
      expect(page).to have_no_link('購入画面に進む'), href: item_orders_path(@item1)
    end
    it 'ログインしていないと商品の購入ができない' do
      # トップページに遷移する
      visit root_path
      # 商品1の詳細ページに遷移する
      visit item_path(@item1)
      # 商品1の購入ページへのリンクが無いことを確認する
      expect(page).to have_no_link('購入画面に進む'), href: item_orders_path(@item1)
      # 商品2の詳細ページに遷移する
      visit item_path(@item2)
      # 商品2の購入ページへのリンクが無いことを確認する
      expect(page).to have_no_link('購入画面に進む'), href: item_orders_path(@item2)
    end
  end

end
