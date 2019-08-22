# frozen_string_literal: true

require 'captchah/encryptor'
require 'captchah/verifier'

RSpec.describe Captchah::Verifier do
  subject { described_class }

  it 'returns :valid status if guess matches truth' do
    truth_payload = Captchah::Encryptor.encrypt(
      truth: all_args[:truth],
      timestamp: Time.current + all_args[:expiry]
    )

    params = create_params(guess: all_args[:truth], truth: truth_payload)

    expect(subject.call(params)).to eq(:valid)
  end

  it 'returns :invalid status if guess does not matche truth' do
    truth_payload = Captchah::Encryptor.encrypt(
      truth: 'not a match',
      timestamp: Time.current + all_args[:expiry]
    )

    params = create_params(guess: all_args[:truth], truth: truth_payload)

    expect(subject.call(params)).to eq(:invalid)
  end

  it 'returns :invalid status if guess is not present' do
    truth_payload = Captchah::Encryptor.encrypt(
      truth: all_args[:truth],
      timestamp: Time.current + all_args[:expiry]
    )

    params = create_params(truth: truth_payload)

    expect(subject.call(params)).to eq(:invalid)
  end

  it 'returns :invalid status if truth is not present' do
    params =  create_params(guess: 'guess')

    expect(subject.call(params)).to eq(:invalid)
  end

  it 'returns :invalid status if truth cannot be decrypted' do
    truth_payload = 'faulty truth'

    params = create_params(guess: all_args[:truth], truth: truth_payload)

    expect(subject.call(params)).to eq(:invalid)
  end

  it 'returns :expired status if guess is not present' do
    truth_payload = Captchah::Encryptor.encrypt(
      truth: all_args[:truth],
      timestamp: Time.current - all_args[:expiry]
    )

    params = create_params(guess: all_args[:truth], truth: truth_payload)

    expect(subject.call(params)).to eq(:expired)
  end

  it 'returns :no_params status if params[:captchah] is not present' do
    expect(subject.call('')).to eq(:no_params)
  end

  def create_params(payload)
    ActionController::Parameters.new(payload)
  end
end
