Rails.application.routes.draw do
	get "/" => "welcome#index"

  resources :my_apps, except: [:show, :index]

	namespace :api, defaults: {format: 'json'} do
	  namespace :v1 do
	    resources :users, only: [:create]
	    resources :polls, controller: 'my_polls', except: [:new, :edit] do
	    	resources :questions, except: [:new, :edit]
	    	resources :answers, only: [:update, :destroy, :create]
				match "*unmatched", via: [:options], to: 'master_api#_xhr_options_request'
	    end
	  end
	end

	get "/auth/:provider/callback" => "sessions#create"

	delete "/logout" => "sessions#destroy"
end
