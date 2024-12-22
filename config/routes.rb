Rails.application.routes.draw do
  resource :session, only: [:new, :create], controller: 'session'

  get '_health', to: proc { [200, { 'Content-Type' => 'application/json' }, [{ status: 'ok' }.to_json]] }

  get "notes(/:title)", to: 'notes#show', as: :note

  resource :network, only: [:show], controller: 'network'
  resource :calendar, only: [:show], controller: 'calendar'

  root to: 'notes#show'
end
