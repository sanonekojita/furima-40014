require 'rails_helper'

RSpec.describe PurchaseRecordShippingAddress, type: :model do
  describe '商品購入情報の保存' do
    before do
      item = FactoryBot.create(:item)
      sleep(0.1)
      user = FactoryBot.create(:user)
      @purchase_record_shipping_address = FactoryBot.build(:purchase_record_shipping_address, user_id: user.id, item_id: item.id)
    end

    context '商品購入ができるとき' do
      it 'すべての値が正しく入力されていれば購入できる' do
        expect(@purchase_record_shipping_address).to be_valid
      end
      it 'buildingは空でも保存できる' do
        @purchase_record_shipping_address.building = ''
        expect(@purchase_record_shipping_address).to be_valid
      end
    end

    context '商品購入ができないとき' do
      it 'tokenが空だと購入できない' do
        @purchase_record_shipping_address.token = ''
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("Token can't be blank")
      end
      it 'postal_codeが空だと購入できない' do
        @purchase_record_shipping_address.postal_code = ''
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("Postal code can't be blank")
      end
      it 'postal_codeが半角のハイフンを含んだ正しい形式でないと購入できない' do
        @purchase_record_shipping_address.postal_code = '523423'
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages)
          .to include('Postal code is invalid. Enter it as follows (e.g. 123-4567)')
      end
      it 'prefecture_idが1では購入できない' do
        @purchase_record_shipping_address.prefecture_id = '1'
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("Prefecture can't be blank")
      end
      it 'cityが空だと購入できない' do
        @purchase_record_shipping_address.city = ''
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("City can't be blank")
      end
      it 'addressesが空だと購入できない' do
        @purchase_record_shipping_address.addresses = ''
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("Addresses can't be blank")
      end
      it 'phone_numberが空だと購入できない' do
        @purchase_record_shipping_address.phone_number = ''
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが9桁以下だと購入できない' do
        @purchase_record_shipping_address.phone_number = '123456789'
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include('Phone number is too short')
      end
      it 'phone_numberが12桁以上だと購入できない' do
        @purchase_record_shipping_address.phone_number = '111111111111'
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include('Phone number is too long')
      end
      it 'phone_numberが0~9以外を含むと購入できない' do
        @purchase_record_shipping_address.phone_number = 'abcdefghijk'
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include('Phone number is invalid. Input only number')
      end
      it 'user_idが紐付いていないと購入できない' do
        @purchase_record_shipping_address.user_id = nil
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("User can't be blank")
      end
      it 'item_idが紐付いていないと購入できない' do
        @purchase_record_shipping_address.item_id = nil
        @purchase_record_shipping_address.valid?
        expect(@purchase_record_shipping_address.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
