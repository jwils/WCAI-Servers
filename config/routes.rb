WCAI::Application.routes.draw do
  resources :servers
  resources :projects

  devise_for :users, :controllers => { :invitations => 'devise/invitations' }
  resources :servers do
    resources :connections, :only => [:index, :new, :destroy]
  end

  resources :connections, :only => [:show, :index]

  resources :users do
    collection do
      post 'batch_invite'
      get 'new_batch'
      get 'index'
    end

    member do
      get 'toggle_lock'
    end

  end

  resources :projects do
    resources :project_files, :only => [:index, :new, :create]
  end


  match "/project_files/:id" => 'project_files#show', :id => /.*/, :as => 'project_file'
  #
  #match 'connection/open' => 'connection#index'

  match 'home/index' => 'home#index', :as => :home_page
  match 'home/about' => 'home#about', :as => :about
  match 'home/contact' => 'home#contact', :as => :contact_us
  match 'server/:id/start' => 'servers#start', :as => :start_server
  match 'server/:id/stop' => 'servers#stop', :as => :stop_server

  root :to => 'passthrough#index'
end
