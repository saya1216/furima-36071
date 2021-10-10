require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品の出品' do
    context '商品が出品できる場合' do
      it 'imageとitem_name、information、category、sales_status、shipping_cost、prefecture、shipping_days、priceが存在すれば保存される' do
        expect(@item).to be_valid
      end
      it 'item_nameが40文字以下であれば出品できる' do
        @item.item_name = 'あ井うえおかきくけこさしすせそ他ちつてとナニヌネノはひふへほまみむめもら利るれろ'
        expect(@item).to be_valid
      end
      it 'informationが1000文字以下であれば出品できる' do
        @item.information = 'あいうえおかきくけこ1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzさしすせそ立ち津手戸ナニヌネノ'
        expect(@item).to be_valid
      end
    end
    context '商品が出品できない場合' do
      it 'imageが存在しなければ出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("商品画像を入力してください")
      end
      it 'item_nameが存在しなければ出品できない' do
        @item.item_name = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("商品名を入力してください")
      end
      it 'informationが存在しなければ出品できない' do
        @item.information = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("商品の説明を入力してください")
      end
      it 'categoryが存在しなければ出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("カテゴリーを入力してください")
      end
      it 'sales_statusが存在しなければ出品できない' do
        @item.sales_status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("商品の状態を入力してください")
      end
      it 'shipping_costが存在しなければ出品できない' do
        @item.shipping_cost_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("配送料の負担を入力してください")
      end
      it 'prefectureが存在しなければ出品できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("発送元の地域を入力してください")
      end
      it 'shipping_daysが存在しなければ出品できない' do
        @item.shipping_days_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("発送までの日数を入力してください")
      end
      it 'priceが存在しなければ出品できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("価格を入力してください")
      end
      it 'item_nameが41文字以上であれば出品できない' do
        @item.item_name = 'あ井うえおかきくけこさしすせそ他ちつてとナニヌネノはひふへほまみむめもら利るれろん'
        @item.valid?
        expect(@item.errors.full_messages).to include("商品名は40文字以内で入力してください")
      end
      it 'informationが1001文字以上であれば出品できない' do
        @item.information = 'i3ekknpu5a0eqc36gghktk556cj6fq4m361p7ljchfsoj427exzr2kqy3gofxbe7ddulsj8rh966s22916dmwzaowtuc3bpz0fkvxscuehnsebjo56dnv1rtuxn909f1rrhzpbb1gvqlwr29ydkwn3jkjbd11fevct8aolba7mbk7paikyrth8g1i1u8peq,
         ygjrw3hwuv5x826mfr91hajeq6a2nse0pkzf0pcx2wngcxsuzfivfbi8kgx9wm1cvtixo7t0aidyiad4oacua6m3luz132aqlttnxvn8f2bv8qo9mjl5iq9dikqa4z6yx475ywh369wouiam0h0wtfys8rr14n94jvkvfjlxxcdflux8eqts87i95zfnn2h8,
         xgv3bsv5s4g8ohqjxp2d6hxvz17dfju2319jokjmv9i588i05ucidnwwilyfp5dgz3a88mc03zbtfv42qmzgmfcnzkarccxquvr4e1b80go3qn05bizwp8s7td0v7cpqdkbqwdnaylj72clsdgva5ftim3ypj9roaohyhfbkxzb4sh9p1tv8ew1u12zlm3mx,
         9hhgqxi0trky9oktojmgch4xaotknwu5t1iw03xir6my4gx4644cycjr3ch57ggni84c7obmsp7868vbbtxnz5tz1rpo7vq5yxk54bgwiffv7gyeark7i3z0k3yzlyr49m7hx6lr182w4wljqsoskj3w7cpnqfqsux7zto41wk9qb7jf77v285ri6z7npwo4jo,
         ixk82hc5fj14zrww25sqjxtn5bdi0k7lal3h4y53kg1553bhk2hi8byyjw4j36zot9lrew65vilcuco9q9wm4qujbs4540n7iygpr6pi853hj0zl069utsum1nacg4k784txe539idgjcmeeq5dday08lmjwkzupadbl47w2qfno2jeuytjqremwzhnfe440vg'
        @item.valid?
        expect(@item.errors.full_messages).to include("商品の説明は1000文字以内で入力してください")
      end
      it 'priceが300円より少ない時は出品できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include("価格は300以上の値にしてください")
      end
      it 'priceが9,999,999円より多い時は出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include("価格は9999999以下の値にしてください")
      end
      it 'priceが全角数字では出品できない' do
        @item.price = '１０００'
        @item.valid?
        expect(@item.errors.full_messages).to include("価格は数値で入力してください")
      end
      it 'ユーザーが紐付いてないと出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
end
