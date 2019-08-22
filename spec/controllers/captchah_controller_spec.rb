# frozen_string_literal: true

require_relative '../../app/controllers/captchah/captchah_controller'

RSpec.describe Captchah::CaptchahController do
  subject { described_class.new }

  let(:decrypted_payload) do
    all_args.slice(
      :id,
      :difficulty,
      :expiry,
      :width,
      :action_label,
      :reload_label,
      :reload_max,
      :reload_count,
      :reload,
      :css,
      :puzzle_font
    )
  end

  let(:decrypted_payload_with_increased_reload_count) do
    decrypted_payload.merge(reload_count: decrypted_payload[:reload_count] + 1)
  end

  let(:encrypted_payload) { 'encrypted_payload' }

  let(:faulty_encrypted_payload) { 'faulty_encrypted_payload' }

  before do
    setup
  end

  it 'increases reload_count and renders successfully' do
    define_params(encrypted_payload)
    expect(subject.new).to eq(:success)
  end

  it 'fails if no params provided' do
    define_params(nil)
    expect(subject.new).to eq(:internal_server_error)
  end

  it 'fails if request is not AJAX' do
    define_params(encrypted_payload)
    allow(subject).to receive_message_chain(:request, :xhr?).and_return(false)
    expect(subject.new).to eq(:forbidden)
  end

  it 'fails if any error is raised' do
    define_params(faulty_encrypted_payload)
    expect(subject.new).to eq(:internal_server_error)
  end

  def define_params(value)
    allow(subject).to(
      receive_message_chain(:params).and_return(captchah: value)
    )
  end

  def setup
    captcha = 'captcha'

    allow(Captchah::Generators::Captcha).to(
      receive(:call)
        .with(decrypted_payload_with_increased_reload_count)
        .and_return(captcha)
    )
    allow(Captchah::Encryptor).to(
      receive(:decrypt).with(encrypted_payload).and_return(decrypted_payload)
    )
    allow(Captchah::Encryptor).to(
      receive(:decrypt).with(faulty_encrypted_payload).and_raise(StandardError)
    )
    allow(subject).to(
      receive(:head)
        .with(:internal_server_error)
        .and_return(:internal_server_error)
    )
    allow(subject).to(
      receive(:head).with(:forbidden).and_return(:forbidden)
    )
    allow(subject).to(
      receive_message_chain(:request, :xhr?).and_return(true)
    )
    allow(subject).to(
      receive_message_chain(:render).with(plain: captcha).and_return(:success)
    )
  end
end
