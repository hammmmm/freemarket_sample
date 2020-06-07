class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :edit, :show,:destroy]
  before_action :set_category, only: [:new, :update, :edit, :show]

  # 商品一覧ページ
  def index
    # 購入日降順、購入済みの商品は非表示にする
    @parents = Category.where(ancestry: nil)
    @ladies = Item.where(purchased_info_id: nil).where(category_id: 1..250).includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @mens = Item.where(purchased_info_id: nil).where(category_id: 251..381).includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @electrical_appliances = Item.where(purchased_info_id: nil).where(category_id: 929..1000).includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @toys = Item.where(purchased_info_id: nil).where(category_id: 716..828).includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @chanel = Item.where(purchased_info_id: nil).where(brand: "シャネル").includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @vuitton = Item.where(purchased_info_id: nil).where(brand: "ヴィトン").includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @supreme = Item.where(purchased_info_id: nil).where(brand: "シュプリーム").includes(:images, :purchased_info).order("created_at DESC").limit(5)
    @nike = Item.where(purchased_info_id: nil).where(brand: "ナイキ").includes(:images, :purchased_info).order("created_at DESC").limit(5)    
  end

  # 商品出品ページ
  def new
    if user_signed_in?
      @item = Item.new
      @item.images.build
    else
      flash[:alert] = "商品の出品にはユーザー登録、もしくはログインをしてください"
      redirect_to new_user_registration_path
    end
  end

  # 商品出品機能
  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:success] = "「#{@item.name}」を出品しました"
      redirect_to root_path
    else
      redirect_to new_item_path, alert: "出品できません。入力必須項目を確認してください"
    end
  end

  def edit
  end  

  def update
    if @item.update(item_update_params)
      flash[:success] = "商品を編集をしました"
      redirect_to item_path(@item.id)
    else
      redirect_to edit_item_path, alert: "編集できません。入力必須項目を確認してください"
    end
  end

  def show
  end

  def set_category
    @parents = Category.where(ancestry: nil)
  end

  def get_category_children
    @category_children = Category.find_by(id: "#{params[:parent_id]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end
  
  def destroy
    if @item.user_id == current_user.id && @item.destroy
      flash[:success] = "「#{@item.name}」を削除しました"
      redirect_to root_path
    else
      render action: :show,
      alert: "「#{@item.name}」を削除出来ませんでした"
    end
  end

  # 商品検索機能
  def search
    @parents = Category.where(ancestry: nil)
    @items = Item.search(params[:keyword])
  end
    
  private

  def item_params
    params.require(:item).permit( :name, 
                                  :description,
                                  :price, 
                                  :size_id,
                                  :category_id, 
                                  :brand,
                                  :condition_id, 
                                  :shipping_fee_side, 
                                  :shipping_day_id, 
                                  :prefecture_id, 
                                  :use_id,
                                  images_attributes: [:image]
                                 ).merge(user_id: current_user.id)
  end

  def item_update_params
    params.require(:item).permit( :name, 
                                  :description,
                                  :price, 
                                  :size_id,
                                  :category_id, 
                                  :brand,
                                  :condition_id, 
                                  :shipping_fee_side, 
                                  :shipping_day_id, 
                                  :prefecture_id, 
                                  :use_id,
                                  images_attributes: [:image, :_destroy, :id]
                                 ).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
    # @imgs = Image.where(item_id: params[:id]) 
  end
end
