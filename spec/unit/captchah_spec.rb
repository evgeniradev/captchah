# frozen_string_literal: true

class TestController < ActionController::Base
  include Captchah
end

RSpec.describe Captchah do
  subject { TestController.new }

  it '#captchah_tag' do
    args = { difficulty: all_args[:difficulty] }
    allow(Captchah::Generators::Captcha).to receive(:call)
    subject.captchah_tag(args)

    expect(Captchah::Generators::Captcha).to have_received(:call).with(args)
  end

  it '#verify_captchah' do
    params = { captchah: 'test_payload' }
    allow(Captchah::Verifier).to receive(:call)
    allow(subject).to receive(:params).and_return(params)
    subject.verify_captchah

    expect(Captchah::Verifier).to have_received(:call).with(params[:captchah])
  end
end
