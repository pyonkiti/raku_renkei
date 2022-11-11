Rails.application.routes.draw do


    
    resources :con37_nyushi_seikyus, only: [:index]

    resources :con37_nyushi_seikyus do
        post :syori_main,       on: :collection
        get  :export_tuki,      on: :collection
        get  :export_yote,      on: :collection
    end

    # root 'con37_nyushi_excels#index'
    root 'con37_nyushi_seikyus#index'

    resources :con37_nyushi_excels, only: [:index]
    
    resources :con37_nyushi_excels do
        post :import1,          on: :collection
        post :import2,          on: :collection
        post :syori0,           on: :collection
        get :export_shi,        on: :collection
        get :export_nyu,        on: :collection
    end

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
