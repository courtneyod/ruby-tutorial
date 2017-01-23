Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  	get 'welcome' => 'welcome#index'

	resources :blog_posts, only: [:index, :new, :create]

end
