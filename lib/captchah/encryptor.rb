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
        secret =
          Rails.application.secrets.secret_key_base.mb_chars.limit(32).to_s

        ActiveSupport::MessageEncryptor.new(secret)
      end
    end
  end
end
