# frozen_string_literal: true

Rails.application.routes.draw do
  post :captchah, to: 'captchah/captchah#new'
end
