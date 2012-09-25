Bookingmegham::Application.routes.draw do
  resources :tooltips do
    collection do
      get 'tooltip_content'
    end
  end

  resources :price_lists

  resources :account_settings, :only => [:show, :edit, :update]

  resources :accounts

	authenticated :user do
		root :to => 'availability_chart#index'
	end

	root :to => 'pages#show', :id => 'home'

	devise_for :users, :path_prefix => 'd', :skip => [:sessions]
	as :user do
		get 'login' => 'devise/sessions#new', :as => :new_user_session
		post 'login' => 'devise/sessions#create', :as => :user_session
		delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
	end

	resources :payments do
		get :email, :on => :member
	end

	resources :taxi_bookings do
		get :email, :on => :member
	end

  resources :payments

  resources :taxi_bookings

  resources :taxis

	controller :availability_chart do
  	get 'availability_chart' => :index
	end

	controller :booking_chart do
  	get 'booking_chart' => :index
	end

  resources :advisors

  resources :agencies do
    get :autocomplete_agency_name, :on => :collection
  end

	resources :trips do
		get :email, :on => :member
	end

  resources :trips

  resources :guests

  resources :room_types

  resources :properties do
    get :room_types_by_property, :on => :member
    get :autocomplete_property_name, :on => :collection
  end

  resources :bookings

	resources :users, :except => [:show, :edit, :update] do
		get :change_password, :on => :member
		put :update_password, :on => :member
		get :become, :on => :member
	end

	match "/pages/*id" => 'pages#show', :as => :page, :format => false

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
