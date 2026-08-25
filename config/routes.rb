# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount RailsDevtools::Engine => "/devtools" if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount MissionControl::Jobs::Engine, at: "/jobs"

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  get "/locale/:locale", to: "locales#update", as: :locale

  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"
  get "/offline" => "service_worker#offline"

  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  scope "(:locale)", constraints: { locale: /fr/ }, defaults: { locale: nil } do
    root "static_pages#home"
    get "/contact", to: "static_pages#contact", as: :contact
    post "/contact", to: "static_pages#create_contact"
    get "/privacy-policy", to: "static_pages#privacy_policy", as: :privacy_policy
    get "/terms", to: "static_pages#terms", as: :terms
  end
end
