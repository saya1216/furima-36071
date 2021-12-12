require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe '商品出品', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  context '商品の出品ができたとき' do
    it '商品が出品できると、出品一覧に遷移して、出品した商品が表示されている' do
      # basic_passのメソッドを実行
      basic_pass root_path
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
      find('#item-category').find("option[value='2']").select_option
      find('#item-sales-status').find("option[value='3']").select_option
      find('#item-shipping-fee-status').find("option[value='2']").select_option
      find('#item-prefecture').find("option[value='4']").select_option
      find('#item-scheduled-delivery').find("option[value='3']").select_option
      fill_in 'item-price', with: @item.price
      # 送信した値がDBに保存されていることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(1)
      # トップページには先ほど投稿した商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページには先ほど投稿した商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.item_name)
      # トップページには先ほど投稿した商品が存在することを確認する（値段）
      expect(page).to have_content(@item.price)
    end
  end
  context '商品の出品ができないとき' do
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
      find('#item-category').find("option[value='1']").select_option
      find('#item-sales-status').find("option[value='1']").select_option
      find('#item-shipping-fee-status').find("option[value='1']").select_option
      find('#item-prefecture').find("option[value='1']").select_option
      find('#item-scheduled-delivery').find("option[value='1']").select_option
      fill_in 'item-price', with: ''
      # 送信した値がDBに保存されていないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(0)
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

RSpec.describe '商品情報編集', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '商品情報の編集ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の編集ができる' do
      # 商品1を投稿したユーザーでログインする
      sign_in(@item1.user)
      # 商品1をクリックして商品詳細ページに遷移する
      visit item_path(@item1)
      # 商品の詳細ページに「編集の編集」へのリンクがあることを確認する
      expect(page).to have_link '商品の編集', href: edit_item_path(@item1)
      # 編集ページへ遷移する
      visit edit_item_path(@item1)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(page).to have_selector('img')
      expect(
        find('#item-name').value
      ).to eq @item1.item_name
      expect(
        find('#item-info').value
      ).to eq @item1.information
      expect(page).to have_select('item[category_id]', selected: @item1.category.name)
      expect(page).to have_select('item[sales_status_id]', selected: @item1.sales_status.name)
      expect(page).to have_select('item[shipping_cost_id]', selected: @item1.shipping_cost.name)
      expect(page).to have_select('item[prefecture_id]', selected: @item1.prefecture.name)
      expect(page).to have_select('item[shipping_days_id]', selected: @item1.shipping_days.name)
      expect(
        find('#item-price').value
      ).to eq @item1.price.to_s
      # 登録内容を編集する
      image_path = Rails.root.join('public/images/test2_image.jpg')
      attach_file('item[image]', image_path)
      fill_in 'item-name', with: "#{@item1.item_name}編集"
      fill_in 'item-info', with: "#{@item1.information}編集"
      select('メンズ', from: 'item-category')
      select('未使用に近い', from: 'item-sales-status')
      select('送料込み', from: 'item-shipping-fee-status')
      select('茨城県', from: 'item-prefecture')
      select('4~7日で発送', from: 'item-scheduled-delivery')
      fill_in 'item-price', with: '9999999'
      # 編集してもItemモデルのカウントは変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(0)
      # 商品詳細ページに戻ったことを確認する
      expect(current_path).to eq(item_path(@item1))
      # トップページには先ほど変更した内容の商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページには先ほど変更した内容の商品が存在することを確認する（商品名）
      expect(page).to have_content(@item1.item_name)
      # トップページには先ほど変更した内容の商品が存在することを確認する（値段）
      expect(page).to have_content(9_999_999)
    end
  end

  context '商品情報の編集ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の編集画面には遷移できない' do
      # 商品1を投稿したユーザーでログインする
      sign_in(@item1.user)
      # 商品2をクリックして詳細ページに遷移する
      visit item_path(@item2)
      # 詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item2)
    end
    it 'ログインしていないと商品の編集画面には遷移できない' do
      # トップページに移動する
      visit root_path
      # 商品1の詳細ページに遷移する
      visit item_path(@item1)
      # 商品1の詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item1)
      # 商品2の詳細ページに遷移する
      visit item_path(@item2)
      # 商品2の詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item2)
    end
  end
end

RSpec.describe '商品削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品削除ができるとき' do
    it 'ログインしたユーザーは自らが出品した商品の削除ができる' do
      # 商品1を出品したユーザーでログインする
      sign_in(@item1.user)
      # 商品1の商品詳細ページに遷移する
      visit item_path(@item1)
      # 商品1に「削除」へのリンクがあることを確認する
      expect(page).to have_link('削除'), href: item_path(@item1)
      # 商品を削除するとレコードの数が1減ることを確認する
      expect do
        find_link('削除', href: item_path(@item1)).click
      end.to change { Item.count }.by(-1)
      # トップページに戻ることを確認する
      expect(current_path).to eq(root_path)
      # トップページには商品1の内容が存在しないことを確認する（画像）
      expect(page).to have_selector('img')
      # トップページには商品1の内容が存在しないことを確認する（商品名）
      expect(page).to have_no_content(@item1.item_name)
      # トップページには商品1の内容が存在しないことを確認する（値段）
      expect(page).to have_no_content(@item1.price)
    end
  end
  context '商品削除ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の削除ができない' do
      # 商品1を投稿したユーザーでログインする
      sign_in(@item1.user)
      # 商品2の商品詳細ページに遷移する
      visit item_path(@item2)
      # 商品2に「削除」へのリンクがないことを確認する
      expect(page).to have_no_link '削除', href: item_path(@item2)
    end
    it 'ログインしていないと商品の削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # 商品1の商品詳細ページに遷移する
      visit item_path(@item1)
      # 商品1に「削除」へのリンクがないことを確認する
      expect(page).to have_no_link '削除', href: item_path(@item1)
      # 商品2の商品詳細ページに遷移する
      visit item_path(@item2)
      # 商品2に「削除」へのリンクがないことを確認する
      expect(page).to have_no_link '削除', href: item_path(@item2)
    end
  end
end

RSpec.describe '商品詳細', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  it 'ログインしたユーザーは商品詳細ページに遷移して「商品の編集」と「削除」が表示される' do
    # ログインする
    sign_in(@item.user)
    # 詳細ページに遷移する
    visit item_path(@item)
    # 詳細ページに商品の内容が含まれている
    expect(page).to have_selector('img')
    expect(page).to have_content(@item.item_name.to_s)
    expect(page).to have_content(@item.information.to_s)
    expect(page).to have_content(@item.user.nickname.to_s)
    expect(page).to have_content(@item.category.name.to_s)
    expect(page).to have_content(@item.sales_status.name.to_s)
    expect(page).to have_content(@item.shipping_cost.name.to_s)
    expect(page).to have_content(@item.prefecture.name.to_s)
    expect(page).to have_content(@item.shipping_days.name.to_s)
    find('.item-price').set(@item.price)
    # 詳細ページに「商品の編集」と「削除」へのリンクが表示されている
    expect(page).to have_content('商品の編集'), href: edit_item_path(@item)
    expect(page).to have_content('削除'), href: item_path(@item)
  end
  it 'ログインしていない状態で商品詳細ページに遷移できるものの「商品の編集」と「削除」が表示されない' do
    # トップページに移動する
    visit root_path
    # 詳細ページに遷移する
    visit item_path(@item)
    # 詳細ページに商品の内容が含まれている
    expect(page).to have_selector('img')
    find('.name').set(@item.item_name)
    find('.item-explain-box').set(@item.information)
    (all('.detail-item')[0]).set(@item.user.nickname)
    expect(page).to have_content(@item.category.name.to_s)
    expect(page).to have_content(@item.sales_status.name.to_s)
    expect(page).to have_content(@item.shipping_cost.name.to_s)
    expect(page).to have_content(@item.prefecture.name.to_s)
    expect(page).to have_content(@item.shipping_days.name.to_s)
    find('.item-price').set(@item.price)
    # 詳細ページに「商品の編集」と「削除」が表示されない
    expect(page).to have_no_content('商品の編集')
    expect(page).to have_no_content('削除')
  end
end
