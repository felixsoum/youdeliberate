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
  delete 'narratives/:id/comment/:comment_id/remove/', to: 'narratives#remove_comment', as: 'remove_comment'
  post 'narratives/:id/flag/', to: 'narratives#flag', as: 'increment_flag'
  post 'narratives/:id/agree', to: 'narratives#agree', as: 'agree_with_narrative'
  post 'narratives/:id/undo_agree', to: 'narratives#undo_agree', as: 'undo_agree_with_narrative'
  post 'narratives/:id/disagree', to: 'narratives#disagree', as: 'disagree_with_narrative'
  post 'narratives/:id/undo_disagree', to: 'narratives#undo_disagree', as: 'undo_disagree_with_narrative'
  post 'narratives/save', as: 'save_narratives'
  resources :narratives

  # Admin
  get 'admin', to: 'narratives#index', as: 'admin_list'
  get 'admin/setting', to: 'narratives#setting', as: 'admin_setting'
  post 'admin/change', to: 'admin#change_password', as: 'change_password'
  post 'admin/add', to: 'admin#add_admin', as: 'add_admin'
  get 'admin/login',  to: 'sessions#new', as: 'signin'
  delete 'admin/logout', to: 'sessions#destroy', as: 'signout'
  post 'admin/upload', as: 'upload_narrative'
  get 'admin/forget', to: 'sessions#forget_password', as: 'forget_password'
  post 'admin/send', to: 'sessions#send_password', as: 'send_password'
  get 'admin/*any' => redirect('/admin')
  resources :sessions, only: [:new, :create, :destroy]
end
