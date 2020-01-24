Rails.application.routes.draw do


  # get 'home/index'
  # get "/users" => redirect("/")
  # get "/users/sign_up" => redirect("/users/sign_in")
  # # devise_for :users
  #
  # devise_for :users, controllers: {sessions: 'users/sessions'}
  #
  # devise_scope :user do
  #   match 'active'            => 'users/sessions#active',               via: :get
  #   match 'timeout'           => 'users/sessions#timeout',              via: :get
  # end
  root 'home#index'

  get '/region_masters/region_master_index' => 'region_masters#region_master_index', :as => 'region_master_index'
  get '/city_town_masters/city_town_master_index' => 'city_town_masters#city_town_master_index', :as => 'city_town_master_index'
  get '/suburb_masters/suburb_master_index' => 'suburb_masters#suburb_master_index', :as => 'suburb_master_index'

  # patch '/entity_info/update'

  get '/activity_types/activity_type_index' => 'activity_types#activity_type_index', :as => 'activity_type_index'
  get '/entity_categories/entity_category_index' => 'entity_categories#entity_category_index', :as => 'entity_category_index'
  get '/entity_infos/entity_info_index' => 'entity_infos#entity_info_index', :as => 'entity_info_index'



  get '/entity_divisions/entity_division_index/:entity_code' => 'entity_divisions#entity_division_index', :as => 'entity_division_index'
  get '/entity_divisions/entity_division_index' => 'entity_divisions#entity_division_index', :as => 'entity_div_index'
  get '/entity_divisions/entity_index' => 'entity_divisions#entity_index', :as => 'entity_index'

  get '/entity_divisions/division_setup/:division_code' => 'entity_divisions#division_setup', :as => 'division_setup'
  post '/division_setup_creation' => 'entity_divisions#create_division_setup', :as => 'create_division_setup'
  get '/entity_divisions/division_edit_setup/:division_code' => 'entity_divisions#division_edit_setup', :as => 'division_edit_setup'
  post '/division_setup_update' => 'entity_divisions#update_division_setup', :as => 'update_division_setup'


  get '/payment_infos/payment_info_index' => 'payment_infos#payment_info_index', :as => 'payment_info_index'


  post '/suburb_masters/city_update', :as => 'suburb_city_ajax_call'
  post '/suburb_masters/suburb_update', :as => 'general_suburb_ajax_call'

  resources :suburb_masters
  resources :city_town_masters
  resources :region_masters
  resources :activity_sub_divs
  resources :activity_divs
  resources :entity_categories
  resources :activity_types
  resources :entity_divisions
  resources :entity_info_extras
  resources :entity_infos
  resources :entity_wallet_configs
  resources :assigned_service_codes
  resources :division_activity_lovs
  resources :activity_sub_div_classes
  resources :payment_infos
  resources :payment_requests
  resources :payment_callbacks

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
