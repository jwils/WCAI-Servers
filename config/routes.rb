WCAI::Application.routes.draw do
  resources :servers
  resources :projects

  devise_for :users, :controllers => { :invitations => 'devise/invitations' }
  

  resources :servers do
    resources :connections, :only => [:index, :new, :destroy]
  end

  resources :connections, :only => [:show]

  resources :users do
    collection do
      post 'batch_invite'
      get 'new_batch'
    end
    resources :connections, :only => [:index]
  end

  resources :projects do
    resources :project_files, :only => [:index, :new, :create]
  end

  resources :project_files, :only => [:show]

  #shows all open connections
  #match 'connection/open' => 'connection#index'

  match 'home/index' => 'home#index', :as => :home_page
  match 'home/about' => 'home#about', :as => :about
  match 'home/contact' => 'home#contact', :as => :contact_us
  match 'server/:id/start' => 'servers#start', :as => :start_server
  match 'server/:id/stop' => 'servers#stop', :as => :stop_server



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
  # See how all your routes lay out with "rake routes"
  root :to => 'passthrough#index'
end
