Rails.application.routes.draw do
  
  get '/' => 'public/homes#top', as: 'top_page'
  get '/about' =>'public/homes#about'
    
  devise_for :customers, skip: [:passwords, :registrations], controllers:{
    sessions: "public/sessions"
  }
  
  devise_scope :customer do
    get 'customers/sign_up' => 'public/registrations#new', as: :new_customer_registration
    post '/customers' => 'public/registrations#create', as: :customer_registration
  end
  
# トップページ
  get '/home' => 'public/customers#show'
# 顧客登録情報編集画面
  get '/customers/edit' => 'public/customers#edit'
  patch '/customers/update' => 'public/customers#update'
# 顧客の退会確認画面
  get '/customers/confirm' => 'public/customers#confirm'
  patch '/customers/withdraw' => 'public/customers#withdraw'
  
# 配送先登録/一覧画面
  get '/addresses' => 'public/addresses#index'
  post '/addresses' => 'public/addresses#create'
  delete '/addresses/:id' => 'public/addresses#destroy', as: :destroy_address
# 配送先編集画面
  get '/addresses/:id/edit' => 'public/addresses#edit', as: :edit_address
  patch '/addresses/:id/edit' => 'public/addresses#update'
# public商品一覧画面
  get '/items' => 'public/items#index', as: :public_items
  get 'items/:id' => 'public/items#show', as: :public_item
# publicカート内商品データ
  get '/cart_items' => 'public/cart_items#index', as: :cart_items
  post '/cart_items' => 'public/cart_items#create'
  patch '/cart_items/:id' => 'public/cart_items#update', as: :update_cart_item
  delete '/cart_items/all' => 'public/cart_items#destroy_all', as: :destroy_all_cart_items
  delete '/cart_items/:id' => 'public/cart_items#destroy', as: :destroy_cart_items
# public注文情報画面
  get '/orders/new' => 'public/orders#new', as: :new_public_order
  post '/orders/confirm' => 'public/orders#confirm', as: :confirm_public_order
  get '/orders/:id/complete' => 'public/orders#complete', as: :complete_public_order
  post '/orders' => 'public/orders#create'
  get '/orders' => 'public/orders#index', as: :public_orders
  get '/orders/:id' => 'public/orders#show', as: :public_order
  
  
  devise_for :admin, skip: [:registrations, :passwords], controllers:{
    sessions: "admin/sessions"
  }
  namespace :admin do
    resources :genres, only: [:index, :create, :edit, :update]
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:edit, :update]
    resources :orders_details, only: [:update]


      get '/' =>'homes#top'
  end
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
