Rails.application.routes.draw do
	
	get "/" => "welcome#app", constraints: lambda { |request| !request.session[:user_id].blank? }

	get "/" => "welcome#index"

  resources :my_apps, except: [:show, :index]

	namespace :api, defaults: {format: 'json'} do
	  namespace :v1 do
	    resources :users, only: [:create]
	    resources :polls, controller: 'my_polls', except: [:new, :edit] do
	    	resources :questions, except: [:new, :edit]
	    	resources :answers, only: [:update, :destroy, :create]
	    end
			match "*unmatched", via: [:options], to: 'master_api#_xhr_options_request'
	    resources :my_answers, only: [:create]
	  end
	end

	get "/auth/:provider/callback" => "sessions#create"

	delete "/logout" => "sessions#destroy"
end
