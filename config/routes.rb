Rails.application.routes.draw do


  namespace :api do
    post 'palestras/organize_conference', to: 'palestras#organize_conference'
  end
   root "palestras#index"


   get 'palestra/import/new', to: 'palestras#new_import', as: 'import_new_palestras'
   post '/import_data', to: 'palestras#import_data'
   
  #  get 'api/data', to: 'pages#api_data'


end
