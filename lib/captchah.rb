# frozen_string_literal: true

require 'captchah/version'
require 'captchah/generators/html'
require 'captchah/generators/puzzle'
require 'captchah/generators/truth'
require 'captchah/generators/captcha'
require 'captchah/base64_images'
require 'captchah/encryptor'
require 'captchah/verifier'

module Captchah
  class Error < StandardError; end

  class Engine < Rails::Engine
  end

  def self.included(base)
    return unless base.respond_to?(:helper_method)

    return unless base.ancestors.include?(ActionController::Base)

    base.helper_method(:captchah_tag, :verify_captchah)
  end

  def captchah_tag(*args)
    Generators::Captcha.call(*args)
  end

  def verify_captchah
    Verifier.call(params[:captchah])
  end
end
