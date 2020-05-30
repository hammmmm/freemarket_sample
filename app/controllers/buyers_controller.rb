class BuyersController < ApplicationController
  require "payjp"
  before_action :move_to_signed_in
  before_action :set_card, :set_item, :buy_item

  def index
    if @card.blank?
      #登録された情報がない場合にカード登録画面に移動
      redirect_to new_card_path
      flash[:alert] = '商品の購入にはクレジットカードの登録が必要です'
    elsif @item.user_id == current_user.id
      redirect_to item_path(@item)
      flash[:alert] = "#{current_user.profile.nickname}さんの出品された商品は購入できません"
    end
  end

  def buy
    # すでに購入されていないか？
    if @item.purchased_info_id.present? 
      redirect_back(fallback_location: root_path) 
      flash[:alert] = '既に購入された商品です。'
    else
      # 決済処理に移行
      Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
      # 請求を発行
      Payjp::Charge.create(
      amount: @item.price,
      customer: @card.customer_id,
      currency: 'jpy'     # 日本円
      )
      # 購入したので、purchased_infoの情報をアップデートして売り切れにします。
      @purchased_info = PurchasedInfo.new
      @today = Date.today
      if @purchased_info.update(user_id: current_user.id, item_id: @item.id, purchase_date: @today, shipping_fee: @item.shipping_fee_side)
        @item.update(purchased_info_id: @purchased_info.id)
        flash[:notice] = '商品を購入しました。'
        redirect_to root_path
      else
        flash[:alert] = '商品の購入に失敗しました。'
        redirect_to controller: 'items', action: 'index'
      end
    end
  end

  private
  def set_card
    @card = CreditCard.where(user_id: current_user.id).first if CreditCard.where(user_id: current_user.id).present?
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_signed_in
    unless user_signed_in?
      redirect_to new_user_session_path
      flash[:alert] = '商品の購入にはログインが必要です'
    end
  end

  def buy_item
    if @item.purchased_info_id.present? 
      redirect_back(fallback_location: root_path) 
      flash[:alert] = '既に購入された商品です。'
    end
  end
end
