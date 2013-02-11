WCAI::Application.routes.draw do
  resources :time_entries


  resources :timesheets


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
      put 'toggle_lock'
    end

  end

  resources :projects do
    resources :project_files, :except => :show
    match "/project_files/:file" => 'project_files#show', :file => /.+/, :as => 'project_file'
  end


  #
  #match 'connection/open' => 'connection#index'

  match 'home/index' => 'home#index', :as => :home_page
  match 'home/about' => 'home#about', :as => :about
  match 'home/contact' => 'home#contact', :as => :contact_us
  match 'how_to/create_users' => 'home#create_users', :as => :how_to_create_users
  match 'how_to/create_projects' => 'home#create_projects', :as => :how_to_create_projects
  match 'how_to/upload_files' => 'home#upload_files', :as => :how_to_upload_files

  match 'server/:id/start' => 'servers#start', :as => :start_server
  match 'server/:id/stop' => 'servers#stop', :as => :stop_server

  root :to => 'passthrough#index'
end
