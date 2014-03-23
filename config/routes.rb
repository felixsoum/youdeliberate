App60::Application.routes.draw do
  # User
  root 'user#index'
  get 'user' => redirect('/')
  get 'user/index' => redirect('/')
  get 'user/about', as: 'about'
  get 'user/contact', as: 'contact'
  get 'user/tutorial', as: 'tutorial'
  get 'share/:id', to: 'user#index', as: 'share_narrative'

  # Narratives
  get 'sunburst' => 'narratives#sunburst'
  get 'narratives/:id/play', to: 'narratives#play', as: 'play_narrative'
  post 'narratives/:id/comment/', to: 'narratives#comment', as: 'comment_add'
  post 'narratives/:id/flag/', to: 'narratives#flag', as: 'increment_flag'
  post 'narratives/:id/agree', to: 'narratives#agree', as: 'agree_with_narrative'
  post 'narratives/:id/undo_agree', to: 'narratives#undo_agree', as: 'undo_agree_with_narrative'
  post 'narratives/:id/disagree', to: 'narratives#disagree', as: 'disagree_with_narrative'
  post 'narratives/:id/undo_disagree', to: 'narratives#undo_disagree', as: 'undo_disagree_with_narrative'
  resources :narratives
  # Admin
  get 'admin', to: 'narratives#index', as: 'admin_list'
  get 'admin/login',  to: 'sessions#new', as: 'signin'
  delete 'admin/logout', to: 'sessions#destroy', as: 'signout'
  post 'admin/upload', as: 'upload_narrative'
  get 'admin/*any' => redirect('/admin')
  resources :sessions, only: [:new, :create, :destroy]
	
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
