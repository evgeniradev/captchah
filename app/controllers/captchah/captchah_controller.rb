# frozen_string_literal: true

module Captchah
  class CaptchahController < ActionController::API
    def new
      return head(:forbidden) unless request.xhr?

      render plain: captchah_tag
    rescue StandardError => e
      puts "Captchah #{e.class.name}: #{e.message}"
      head :internal_server_error
    end

    private

    def payload
      @payload ||= begin
        raise Error, 'Payload missing' if captchah_params.blank?

        Encryptor.decrypt(captchah_params)
      end
    end

    def captchah_tag
      Generators::Captcha.call(captchah_arguments)
    end

    def captchah_arguments
      {
        id: payload[:id],
        difficulty: payload[:difficulty],
        expiry: payload[:expiry],
        width: payload[:width],
        action_label: payload[:action_label],
        reload_label: payload[:reload_label],
        reload_max: payload[:reload_max],
        reload_count: payload[:reload_count] + 1,
        reload: payload[:reload],
        css: payload[:css],
        puzzle_font: payload[:puzzle_font]
      }
    end

    def captchah_params
      @captchah_params ||= params[:captchah]
    end
  end
end
