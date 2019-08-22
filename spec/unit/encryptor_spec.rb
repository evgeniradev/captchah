# frozen_string_literal: true

require 'captchah/encryptor'

RSpec.describe Captchah::Encryptor do
  subject { described_class }

  let(:decrypted_value) { 'value' }
  let(:encrypted_value) { subject.encrypt(decrypted_value) }
  let(:returned_encrypted_value) { 'returned_encrypted_value' }

  it 'encrypts and encodes' do
    encrypts_and_encodes_setup
    subject.encrypt(decrypted_value)
    expect(Base64).to(
      have_received(:strict_encode64).with(returned_encrypted_value)
    )
  end

  it 'decrypts and decodes' do
    expect(subject.decrypt(encrypted_value)).to eq(decrypted_value)
  end

  def encrypts_and_encodes_setup
    encryptor = instance_double(ActiveSupport::MessageEncryptor)

    allow(encryptor).to(
      receive(:encrypt_and_sign)
        .with(decrypted_value)
        .and_return(returned_encrypted_value)
    )

    allow(ActiveSupport::MessageEncryptor).to(
      receive(:new).and_return(encryptor)
    )

    allow(Base64).to receive(:strict_encode64)
  end
end
