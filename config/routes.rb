Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # root 'con37_nyushi_excels#index'
    # root 'con37_nyushi_seikyus#index'
    # root 'master/users#index'
    root 'master/sessions#new'

    namespace :master do
        get    '/login',  to: 'sessions#new'
        post   '/login',  to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
    end
    
    namespace :master do
        resources :users
    end

    resources :con37_nyushi_seikyus, only: [:index]

    resources :con37_nyushi_seikyus do
        post  :syori_main,       on: :collection
        get   :export_tuki,      on: :collection
        get   :export_yote,      on: :collection
    end

    resources :con37_nyushi_excels, only: [:index]
    
    resources :con37_nyushi_excels do
        post  :import1,          on: :collection
        post  :import2,          on: :collection
        post  :syori0,           on: :collection
        get   :export_shi,       on: :collection
        get   :export_nyu,       on: :collection
    end
end
