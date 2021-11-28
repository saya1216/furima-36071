require 'rails_helper'

RSpec.describe "商品出品", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  context '商品の出品ができたとき'do
    it '商品が出品できると、出品一覧に遷移して、出品した商品が表示されている' do
      # ログインする
      sign_in(@user)
      # 商品出品ページへのボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 出品ページに移動する
      click_on('出品する') 
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('item[image]', image_path)
      # 商品情報を入力する
      fill_in 'item-name', with: @item.item_name
      fill_in 'item-info', with: @item.information
      find("#item-category").find("option[value='2']").select_option
      find("#item-sales-status").find("option[value='3']").select_option
      find("#item-shipping-fee-status").find("option[value='2']").select_option
      find("#item-prefecture").find("option[value='4']").select_option
      find("#item-scheduled-delivery").find("option[value='3']").select_option
      fill_in 'item-price', with: @item.price
      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページには先ほど投稿した商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページには先ほど投稿した商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.item_name)
      # トップページには先ほど投稿した商品が存在することを確認する（値段）
      expect(page).to have_content(@item.price)
    end
  end
  context '商品の出品ができないとき'do
    it 'ログインしたが、誤った情報のため商品を出品できず、商品出品ページに戻る' do
      # ログインする
      sign_in(@user)
      # 商品出品ページへのボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 出品ページに移動する
      click_on('出品する') 
      # 商品情報を入力する
      fill_in 'item-name', with: ''
      fill_in 'item-info', with: ''
      find("#item-category").find("option[value='1']").select_option
      find("#item-sales-status").find("option[value='1']").select_option
      find("#item-shipping-fee-status").find("option[value='1']").select_option
      find("#item-prefecture").find("option[value='1']").select_option
      find("#item-scheduled-delivery").find("option[value='1']").select_option
      fill_in 'item-price', with: ''
      # 送信した値がDBに保存されていないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Item.count }.by(0)
      # エラーメッセージがあることを確認する
      expect(page).to have_content('商品画像を入力してください')
      expect(page).to have_content('商品名を入力してください')
      expect(page).to have_content('商品の説明を入力してください')
      expect(page).to have_content('カテゴリーを入力してください')
      expect(page).to have_content('商品の状態を入力してください')
      expect(page).to have_content('配送料の負担を入力してください')
      expect(page).to have_content('発送元の地域を入力してください')
      expect(page).to have_content('発送までの日数を入力してください')
      expect(page).to have_content('価格を入力してください')
      expect(page).to have_content('価格は不正な値です')
      expect(page).to have_content('価格は数値で入力してください')
     # 出品ページへ戻されることを確認する
      expect(current_path).to eq(items_path)
    end
  end
  
end
