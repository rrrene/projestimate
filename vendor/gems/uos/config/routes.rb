Uos::Engine.routes.draw do
  root :to => 'inputs#index'
  post "save_uos" => "inputs#save_uos", :as => "save_uos"
  get 'load_gross' => 'inputs#load_gross', :as => 'load_gross'
end