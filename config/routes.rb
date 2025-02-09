Rails.application.routes.draw do
  resources :external_services_params
  root 'home#index'
  #devise_for :users
   get "/users" => redirect("/")
   #get "/users/sign_up" => redirect("/users/sign_in")
    devise_for :users
  #
  # devise_for :users, controllers: {sessions: 'users/sessions'}
  #
  # devise_scope :user do
  #   match 'active'            => 'users/sessions#active',               via: :get
  #   match 'timeout'           => 'users/sessions#timeout',              via: :get
  # end

  get '/users/user_index' => 'users#user_index', :as => 'user_index'
  get '/users/validator_index' => 'users#validator_index', :as => 'validator_index'
  #get '/users/scanner_user_index' => 'users#scanner_user_index', :as => 'scanner_user_index'
  get '/users/index' => 'users#index', :as => 'main_users'
  get '/users/new' => 'users#new', :as => 'user_new'
  get '/users/new_validator' => 'users#new_validator', :as => 'user_new_validator'
  post '/users/create' => 'users#create', :as => 'user_create'
  #post '/scanner/create' => 'users#scanner_user_create', :as => 'scanner_user_create'
  get '/users/:id/edit' => 'users#edit', :as => 'user_edit'
  get '/users/:id/scanner_edit' => 'users#scanner_edit', :as => 'scanner_edit'
  get '/users/:id' => 'users#show', :as => 'user_show'
  put '/users/:id' => 'user#update', :as => 'user_update'
  #put '/users/scanner_user/:id' => 'user#scanner_user_update', :as => 'scanner_user_update'
  patch '/users/:id' => 'users#update'
  delete '/users/:id' => 'users#destroy', :as => 'user_delete'
  post '/unlock_user' => 'users#unlock_user'

  get '/roles/role_index' => 'roles#role_index', :as => 'role_index'

  get '/home/home_index' => 'home#home_index', :as => 'home_index'


  get '/region_masters/region_master_index' => 'region_masters#region_master_index', :as => 'region_master_index'
  get '/city_town_masters/city_town_master_index' => 'city_town_masters#city_town_master_index', :as => 'city_town_master_index'
  get '/suburb_masters/suburb_master_index' => 'suburb_masters#suburb_master_index', :as => 'suburb_master_index'

  # patch '/entity_info/update'

  get '/activity_types/activity_type_index' => 'activity_types#activity_type_index', :as => 'activity_type_index'

  get '/activity_categories/activity_category_index' => 'activity_categories#activity_category_index', :as => 'activity_category_index'
  get '/activity_groups/activity_group_index' => 'activity_groups#activity_group_index', :as => 'activity_group_index'

  get '/assigned_fees/assigned_fee_index' => 'assigned_fees#assigned_fee_index', :as => 'assigned_fee_index'


  get '/entity_categories/entity_category_index' => 'entity_categories#entity_category_index', :as => 'entity_category_index'
  get '/entity_infos/entity_info_index' => 'entity_infos#entity_info_index', :as => 'entity_info_index'


  get '/entity_divisions/entity_division_index/:entity_code' => 'entity_divisions#entity_division_index', :as => 'entity_division_index'
  get '/entity_divisions/entity_division_index' => 'entity_divisions#entity_division_index', :as => 'entity_div_index'
  get '/entity_divisions/entity_index' => 'entity_divisions#entity_index', :as => 'entity_index'
  get '/entity_infos/sports_index' => 'entity_infos#sports_index', :as => 'sports_index'
  get '/entity_divisions/main_sports_index/:entity_code' => 'entity_divisions#main_sports_index', :as => 'main_sports_index'
  get '/entity_divisions/main_sports_index' => 'entity_divisions#main_sports_index'
  post '/entity_divisions/entity_div_create' => 'entity_divisions#entity_div_create', :as => 'entity_div_create'


  get '/entity_divisions/division_setup/:division_code' => 'entity_divisions#division_setup', :as => 'division_setup'
  post '/division_setup_creation' => 'entity_divisions#create_division_setup', :as => 'create_division_setup'
  get '/entity_divisions/division_edit_setup/:division_code' => 'entity_divisions#division_edit_setup', :as => 'division_edit_setup'
  post '/division_setup_update' => 'entity_divisions#update_division_setup', :as => 'update_division_setup'
  post '/reset_qr_code' => 'entity_divisions#reset_qr_code', :as => 'reset_biz_qr_code'


  get '/entity_divisions/sport_setup/:division_code' => 'entity_divisions#sport_setup', :as => 'sport_setup'
  post '/sport_setup_creation' => 'entity_divisions#create_sport_setup', :as => 'create_sport_setup'
  get '/entity_divisions/sport_edit_setup/:division_code' => 'entity_divisions#sport_edit_setup', :as => 'sport_edit_setup'
  post '/sport_setup_update' => 'entity_divisions#update_sport_setup', :as => 'update_sport_setup'


  get '/entity_div_alert_recipients/entity_div_alert_recipient_index' => 'entity_div_alert_recipients#entity_div_alert_recipient_index', :as => 'entity_div_alert_recipient_index'



  get '/entity_divisions/fixture_new/:division_code' => 'entity_divisions#fixture_new', :as => 'fixture_new'
  post '/fixture_creation' => 'entity_divisions#create_fixture', :as => 'create_fixture'
  get '/entity_divisions/fixture_edit/:act_div_id' => 'entity_divisions#fixture_edit', :as => 'fixture_edit'
  patch '/fixture_update/:act_div_id' => 'entity_divisions#update_fixture', :as => 'update_fixture'


  get '/entity_admin_whitelists/entity_admin_whitelist_index' => 'entity_admin_whitelists#entity_admin_whitelist_index', :as => 'entity_admin_whitelist_index'

  get '/activity_divs/activity_div_index' => 'activity_divs#activity_div_index', :as => 'activity_div_index'

  get '/entity_div_media/entity_div_media_index' => 'entity_div_media#entity_div_media_index', :as => 'entity_div_media_index'
  get '/entity_div_media/image_media' => 'entity_div_media#image_media', :as => 'image_media'
  get '/entity_div_media/video_media' => 'entity_div_media#video_media', :as => 'video_media'
  get '/entity_div_social_handles/entity_div_social_handle_index' => 'entity_div_social_handles#entity_div_social_handle_index', :as => 'entity_div_social_handle_index'
  get 'inner_new' => 'entity_div_media#inner_new', :as => 'inner_new'
  post 'inner_create' => 'entity_div_media#inner_create', :as => 'media_inner_create'
  get '/inner_del/:id' => 'entity_div_media#inner_destroy', :as => 'inner_destroy'

  get '/activity_type_media/activity_type_media_index' => 'activity_type_media#activity_type_media_index', :as => 'activity_type_media_index'
  get '/activity_type_media/image_media' => 'activity_type_media#image_media', :as => 'act_image_media'
  get '/activity_type_media/video_media' => 'activity_type_media#video_media', :as => 'act_video_media'
  get 'inner_new' => 'activity_type_media#inner_new', :as => 'act_inner_new'
  post 'inner_create' => 'activity_type_media#inner_create', :as => 'act_media_inner_create'
  get '/inner_del/:id' => 'activity_type_media#inner_destroy', :as => 'act_inner_destroy'

  get '/fund_movements/settlement_entity_info_index' => 'fund_movements#settlement_entity_info_index', :as => 'settlement_entity_info_index'
  get '/fund_movements/settlement_entity_division_index/:entity_code' => 'fund_movements#settlement_entity_division_index', :as => 'settlement_entity_division_index'
  get '/fund_movements/settlement_entity_division_index' => 'fund_movements#settlement_entity_division_index', :as => 'settlement_entity_div_index'
  get '/fund_movements/fund_movement_index/:division_code' => 'fund_movements#fund_movement_index', :as => 'fund_movement_index'
  get '/fund_movements/fund_movement_index' => 'fund_movements#fund_movement_index', :as => 'fund_move_index'



  get '/payment_infos/payment_info_index' => 'payment_infos#payment_info_index', :as => 'payment_info_index'
  #get '/payment_infos/transaction_resend/:id' => 'payment_infos#transaction_resend', :as => 'transaction_resend'
  patch '/payment_infos/transaction_resend/:id' => 'payment_infos#transaction_resend', :as => 'transaction_resend'
  post '/payment_infos/transaction_resend/:id' => 'payment_infos#transaction_resend', :as => 'transactions_resend'
  get '/payment_infos/resend_form/:id' => 'payment_infos#resend_form', :as => 'resend_form'
  get '/payment_infos/resend_show/:id' => 'payment_infos#resend_show', :as => 'resend_show'


  get '/payment_infos/financial_index' => 'payment_infos#financial_index', :as => 'financial_index'
  get '/payment_infos/financial_statement_index' => 'payment_infos#financial_statement_index', :as => 'financial_statement_index'
  get '/payment_infos/wallet_statement_index' => 'payment_infos#wallet_statement_index', :as => 'wallet_statement_index'
  get '/payment_infos/financial_form' => 'payment_infos#financial_form', :as => 'financial_form'
  post '/payment_infos/financial_search' => 'payment_infos#financial_search', :as => 'financial_search'
  post '/payment_infos/wallet_search' => 'payment_infos#wallet_search', :as => 'wallet_search'



  get '/activity_participants/activity_participant_index' => 'activity_participants#activity_participant_index', :as => 'activity_participant_index'
  get '/activity_fixtures/activity_fixture_index' => 'activity_fixtures#activity_fixture_index', :as => 'activity_fixture_index'
  get '/activity_div_cats/activity_div_cat_index' => 'activity_div_cats#activity_div_cat_index', :as => 'activity_div_cat_index'
  get '/activity_category_divs/activity_category_div_index/:div_cat_id' => 'activity_category_divs#activity_category_div_index', :as => 'activity_category_div_index'

  get '/sub_activity_masters/sub_activity_master_index' => 'sub_activity_masters#sub_activity_master_index', :as => 'sub_activity_master_index'
  get '/entity_div_sub_activities/entity_div_sub_activity_index' => 'entity_div_sub_activities#entity_div_sub_activity_index', :as => 'entity_div_sub_activity_index'

  get '/loan_requests/loan_request_index' => 'loan_requests#loan_request_index', :as => 'loan_request_index'
  get '/client_webhook_configs/client_webhook_index' => 'client_webhook_configs#client_webhook_index', :as => 'client_webhook_index'
  get '/entity_div_ref_lookups/entity_div_ref_lookup_index' => 'entity_div_ref_lookups#entity_div_ref_lookup_index', :as => 'entity_div_ref_lookup_index'



  # ================== DASHBOARD ROUTES =======================
  get '/reports' => 'dashboard#index', :as => 'reports'
  get '/report_index' => 'dashboard#report_index', :as => 'report_index'

  # =================== AJAX ROUTES ===========================
  post '/suburb_masters/city_update', :as => 'suburb_city_ajax_call'
  post '/suburb_masters/suburb_update', :as => 'general_suburb_ajax_call'
  post '/entity_divisions/category_div_update', :as => 'div_cat_to_cat_div_ajax_call'
  post '/entity_divisions/fixture_update', :as => 'cat_div_to_fixture_ajax_call'
  post '/entity_divisions/division_update', :as => 'general_division_ajax_call'
  # post '/entity_divisions/multi_division_update', :as => 'general_multi_division_ajax_call'
  post '/entity_divisions/lov_update', :as => 'general_lov_ajax_call'
  post '/entity_divisions/ref_update', :as => 'general_ref_ajax_call'
  post '/activity_sub_div_classes/classification_update', :as => 'general_class_ajax_call'
  post '/activity_sub_div_classes/ticket_update', :as => 'general_ticket_ajax_call'
  #post '/users/divisions', :as => 'general_role_ajax_call'



  resources :suburb_masters
  resources :city_town_masters
  resources :region_masters
  resources :activity_sub_divs
  resources :activity_divs
  resources :entity_categories
  resources :activity_types
  resources :entity_divisions
  resources :entity_div_ref_lookups
  resources :entity_info_extras
  resources :entity_infos
  resources :entity_wallet_configs
  resources :assigned_service_codes
  resources :division_activity_lovs
  resources :activity_sub_div_classes
  resources :payment_infos
  resources :payment_requests
  resources :payment_callbacks
  resources :entity_service_account_trxns
  resources :entity_service_accounts
  resources :activity_participants
  resources :activity_fixtures
  resources :activity_category_divs
  resources :activity_categories
  resources :activity_div_cats
  resources :permission_roles
  resources :permissions
  resources :roles
  resources :assigned_fees
  resources :entity_admin_whitelists
  resources :sub_activity_masters
  resources :entity_div_sub_activities
  resources :fund_movements
  resources :entity_div_alert_recipients
  resources :entity_div_social_handles
  resources :entity_div_media
  resources :activity_groups
  resources :activity_type_media
  resources :user_roles
  resources :multi_user_roles
  resources :loan_requests
  resources :client_webhook_configs




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
