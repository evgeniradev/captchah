# frozen_string_literal: true

module Captchah
  class Verifier
    def self.call(params)
      return :no_params unless params.present?

      return :invalid if params[:guess].blank? || params[:truth].blank?

      truth_payload = Encryptor.decrypt(params[:truth])

      guess = params[:guess].downcase.delete(' ')

      return :expired unless truth_payload[:timestamp] >= Time.current

      return :valid if guess == truth_payload[:truth].downcase

      :invalid
    rescue ArgumentError, ActiveSupport::MessageEncryptor::InvalidMessage
      :invalid
    end
  end
end
