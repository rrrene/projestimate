Uos::Engine.routes.draw do
  root :to => 'inputs#index'
  get 'load_gross' => 'inputs#load_gross', :as => 'load_gross'
end