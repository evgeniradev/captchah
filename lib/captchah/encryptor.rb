# frozen_string_literal: true

module Captchah
  class Encryptor
    class << self
      def encrypt(value)
        Base64.strict_encode64(encryptor.encrypt_and_sign(value))
      end

      def decrypt(value)
        encryptor.decrypt_and_verify(Base64.strict_decode64(value))
      end

      private

      def encryptor
        secret_key_base = Rails.application.secrets.secret_key_base

        ActiveSupport::MessageEncryptor.new(secret_key_base)
      end
    end
  end
end
