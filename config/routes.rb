Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # テスト時に利用
    # root 'con37_nyushi_excels#index'
    # root 'con37_nyushi_seikyus#index'
    # root 'master/users#index'

    root 'master/sessions#new'

    # ログイン
    namespace :master do
        get    '/login',  to: 'sessions#new'
        post   '/login',  to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
    end

    # ユーザー一覧
    namespace :master do
        resources :users
    end

    # 請求計算
    resources :con37_nyushi_seikyus, only: [:index]
    
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
