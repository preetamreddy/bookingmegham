Bookingmegham::Application.routes.draw do

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

  resources :trek_prices

  resources :trek_bookings

  resources :treks

  resources :taxi_bookings

  resources :taxis

	controller :sessions do
		get 'login' => :new
		post 'login' => :create
		delete 'logout' => :destroy
	end

	controller :availability_chart do
  	get 'availability_chart' => :index
	end

  controller :line_items do
		get 'booking_chart' => :index
	end

  resources :advisors

  resources :agencies

	resources :trips do
		get :email, :on => :member
	end

  resources :feedbacks, :except => :destroy

  resources :value_added_services

  resources :trips

  resources :guests

  resources :room_types

  resources :properties

  resources :bookings

	resources :users, :except => :show

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#new', as: 'login'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
