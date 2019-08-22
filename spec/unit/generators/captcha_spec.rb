# frozen_string_literal: true

require 'captchah/generators/captcha'

RSpec.describe Captchah::Generators::Captcha do
  subject { described_class }

  let(:current_time) { Time.current }

  let(:captcha_generator_args) do
    all_args.except(:puzzle, :truth, :truth_payload, :reload_payload)
  end

  let(:html_generator_args) do
    all_args.slice(*Captchah::Generators::Html::ATTR_NAMES)
  end

  let(:truth_generator_args) do
    all_args[:difficulty]
  end

  let(:puzzle_generator_args) do
    [all_args[:truth], all_args[:difficulty], all_args[:puzzle_font]]
  end

  let(:encryptor_truth_payload_args) do
    {
      truth: all_args[:truth],
      timestamp: current_time + all_args[:expiry]
    }
  end

  let(:encryptor_reload_payload_args) do
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

  let(:reload_max_reached_encryptor_reload_payload_args) do
    encryptor_reload_payload_args
      .merge(reload_count: encryptor_reload_payload_args[:reload_max] + 1)
  end

  let(:reload_max_reached_html_generator_args) do
    html_generator_args.merge(reload: false, reload_payload: nil)
  end

  let(:default_html_generator_args) do
    html_generator_args.merge(
      width: subject::DEFAULT_WIDTH,
      action_label: subject::DEFAULT_ACTION_LABEL,
      reload_label: subject::DEFAULT_RELOAD_LABEL
    )
  end

  let(:default_truth_generator_args) do
    subject::DEFAULT_DIFFICULTY
  end

  let(:default_puzzle_generator_args) do
    [all_args[:truth],
     subject::DEFAULT_DIFFICULTY,
     subject::DEFAULT_PUZZLE_FONT]
  end

  let(:default_encryptor_truth_payload_args) do
    encryptor_truth_payload_args.merge(
      timestamp: current_time + subject::DEFAULT_EXPIRY
    )
  end

  let(:default_encryptor_reload_payload_args) do
    encryptor_reload_payload_args.merge(
      difficulty: subject::DEFAULT_DIFFICULTY,
      expiry: subject::DEFAULT_EXPIRY,
      width: subject::DEFAULT_WIDTH,
      action_label: subject::DEFAULT_ACTION_LABEL,
      reload_label: subject::DEFAULT_RELOAD_LABEL,
      reload_max: subject::DEFAULT_RELOAD_MAX,
      reload_count: subject::DEFAULT_RELOAD_COUNT,
      puzzle_font: subject::DEFAULT_PUZZLE_FONT
    )
  end

  before do
    shared_setup
  end

  context 'with default arguments' do
    it 'calls relevant service classes' do
      with_default_arguments_context_setup

      subject.call

      expect(Captchah::Generators::Html).to(
        have_received(:call).with(default_html_generator_args)
      )
    end
  end

  context 'with specified arguments' do
    before do
      with_specified_arguments_context_setup
    end

    it 'calls relevant service classes' do
      subject.call(captcha_generator_args)

      expect(Captchah::Generators::Html).to(
        have_received(:call).with(html_generator_args)
      )
    end

    it 'disables reload if max reloads reached' do
      allow(Captchah::Encryptor).to(
        receive(:encrypt)
          .with(reload_max_reached_encryptor_reload_payload_args)
          .and_return('reload_payload')
      )

      subject.call(reload_max_reached_encryptor_reload_payload_args)

      expect(Captchah::Generators::Html).to(
        have_received(:call).with(reload_max_reached_html_generator_args)
      )
    end

    it "raises error if 'difficulty' argument is a value above 5" do
      captcha_generator_args[:difficulty] = 6

      expect { subject.call(captcha_generator_args) }
        .to(
          raise_error(
            Captchah::Error,
            "'difficulty' must be an Integer value between 1 and 5."
          )
        )
    end

    it "raises error if 'expiry' argument is not a duration" do
      captcha_generator_args[:expiry] = :not_a_duration

      expect { subject.call(captcha_generator_args) }
        .to(
          raise_error(
            Captchah::Error,
            "'expiry' must be an ActiveSupport::Duration object."
          )
        )
    end
  end

  def shared_setup
    allow(Time).to receive(:current).and_return(current_time)
    allow(SecureRandom).to receive(:uuid).and_return(all_args[:id])
    allow(Captchah::Generators::Html).to receive(:call)
  end

  def with_default_arguments_context_setup
    allow(Captchah::Encryptor).to(
      receive(:encrypt)
        .with(default_encryptor_truth_payload_args)
        .and_return(all_args[:truth_payload])
    )
    allow(Captchah::Encryptor).to(
      receive(:encrypt)
        .with(default_encryptor_reload_payload_args)
        .and_return(all_args[:reload_payload])
    )
    allow(Captchah::Generators::Truth).to(
      receive(:call)
        .with(default_truth_generator_args)
        .and_return(all_args[:truth])
    )
    allow(Captchah::Generators::Puzzle).to(
      receive(:call)
        .with(*default_puzzle_generator_args)
        .and_return(all_args[:puzzle])
    )
  end

  def with_specified_arguments_context_setup
    allow(Captchah::Encryptor).to(
      receive(:encrypt)
        .with(encryptor_truth_payload_args)
        .and_return(all_args[:truth_payload])
    )
    allow(Captchah::Encryptor).to(
      receive(:encrypt)
        .with(encryptor_reload_payload_args)
        .and_return(all_args[:reload_payload])
    )
    allow(Captchah::Generators::Truth).to(
      receive(:call)
        .with(truth_generator_args)
        .and_return(all_args[:truth])
    )
    allow(Captchah::Generators::Puzzle).to(
      receive(:call)
        .with(*puzzle_generator_args)
        .and_return(all_args[:puzzle])
    )
  end
end
