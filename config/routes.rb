Rails.application.routes.draw do
  
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
    # テスト時に利用
    # root 'con37_nyushi_excels#index'
    # root 'con37_nyushi_seikyus#index'
    # root 'master/users#index'
    # root 'con36_cloud_renkeis#index'
    
    # 本番用
    root 'master/sessions#new'
    
    # ログイン
    namespace :master do
        get    '/login',  to: 'sessions#new'
        post   '/login',  to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
    end
    
    # Cloud連携
    resources :con36_cloud_renkeis, only: [:index]

    # ユーザー一覧
    namespace :master do
        resources :users
    end
    
    # Cloud連携
    resources :con36_cloud_renkeis do
        get   :export_user,     on: :collection
        get   :export_shisetu,  on: :collection
        post  :import_seikyu,   on: :collection
        post  :import_shisetu,  on: :collection
    end

    # 請求計算
    resources :con37_nyushi_seikyus, only: [:index, :create]
    
    # 請求計算

    resources :con37_nyushi_seikyus do
        post  :syori_main,       on: :collection
        get   :export_tuki,      on: :collection
        get   :export_yote,      on: :collection
    end

    # 入金仕入
    resources :con37_nyushi_excels, only: [:index]

    # 入金仕入
    resources :con37_nyushi_excels do
        post  :import1,          on: :collection
        post  :import2,          on: :collection
        post  :syori0,           on: :collection
        get   :export_shi,       on: :collection
        get   :export_nyu,       on: :collection
    end
end
