Rails.application.routes.draw do
  get 'report_pdfs/index'
  # 重複して選択する可能性のあるものは下におく
  get "about" => "home#about"
  get "/" => "home#top"

  post "records/:month/submit" => "records#submit"
  get "records/:month/:id/edit" => "records#edit"
  post "records/:month/:id/update" => "records#update"
  post "records/:month/:id/destroy" => "records#destroy"
  get 'records/:month' => "records#index"
  get 'records' => "records#top"

  post "users/create" => "home#user_create"
  post "users/login" => "home#user_login"
  post "users/logout" => "home#user_logout"

  get "menu" => "home#menu"
  get "menu/report/:month/display" => "report_pdfs#display"
  get "menu/report/:month" => "report_pdfs#index"
  post "menu/inquiry" => "home#inquiry"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
