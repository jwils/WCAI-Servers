WCAI::Application.routes.draw do
  #Redirect since we changed server location
  match 'projects/projects' => redirect('/projects')

  resources :timesheets
  match 'timesheets/:id/approve' => 'timesheets#approve', :as => :approve_timesheet

  devise_for :users, :controllers => { :invitations => 'devise/invitations' }, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
    end

  resources :users do
    collection do
      post 'batch_invite'
      get 'new_batch'
      get 'index'
    end

    member do
      put 'toggle_lock', :as => :toggle_lock
    end

  end

  resources :servers

  resources :servers do
    resources :connections

    member do
      get 'start', :as => :start
      get 'stop', :as => :stop
    end
  end

  resources :projects

  resources :projects do
    resources :project_files, :except => :show
    match '/project_files/:file' => 'project_files#show', :file => /.+/, :as => 'project_file'
  end

  match 'contact' => 'messages#new', :as => 'contact_us', :via => :get
  match 'contact' => 'messages#create', :as => 'contact_us', :via => :post

  #
  #match 'connection/open' => 'connection#index'

  match 'home/index' => 'home#index', :as => :home_page
  match 'home/about' => 'home#about', :as => :about

  resource :tutorial do
    get 'create_users'
    get 'create_projects'
    get 'upload_files'
    get 'disable_user'
    get 'linking_aws_folders'
    get 'downloading_files'

  end

  root :to => 'passthrough#index'
end
