WCAI::Application.routes.draw do
  #Redirect since we changed server location
  match 'projects/projects' => redirect('/projects')

  resources :timesheets
  match 'timesheets/:id/approve' => 'timesheets#approve', :as => :approve_timesheet
  match 'timesheets/send_reminder' => 'timesheets#send_timesheet_reminder', :as => :send_timesheet_reminder

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
    resources :s3_files, :except => :show
    match '/s3_files/:file' => 's3_files#show', :file => /.+/, :as => 's3_file'
    resources :ec2_files, :only => :index
    match '/ec2_files/:file' => 'ec2_files#show', :file => /.+/, :as => 'ec2_file'
  end

  match 'home/index' => 'home#index', :as => :home_page
  match 'home/about' => 'home#about', :as => :about
  match 'contact' => 'messages#new', :as => 'contact_us', :via => :get
  match 'contact' => 'messages#create', :as => 'contact_us', :via => :post

  resource :tutorials do
    get 'create_users'
    get 'create_projects'
    get 'upload_files'
    get 'disable_user'
    get 'linking_aws_folders'
    get 'downloading_files'

  end

  root :to => 'passthrough#index'
end
