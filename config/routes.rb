Rails.application.routes.draw do
  post 'links', to: 'urls#links'
  match '*shortened', to: 'urls#shortened', via: :get
end
