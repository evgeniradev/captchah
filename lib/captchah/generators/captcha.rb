# frozen_string_literal: true

module Captchah
  module Generators
    class Captcha
      DEFAULT_DIFFICULTY = 3
      DEFAULT_EXPIRY = 10.minutes
      DEFAULT_WIDTH = 140
      DEFAULT_ACTION_LABEL = 'Type the letters you see:'
      DEFAULT_RELOAD_LABEL = 'Reload'
      DEFAULT_RELOAD_MAX = 5
      DEFAULT_RELOAD_COUNT = 1
      DEFAULT_PUZZLE_FONT = 'Verdana'

      def self.call(*args)
        new(*args).send(:call)
      end

      def initialize(args = {})
        @id = args[:id] || SecureRandom.uuid
        @difficulty = args[:difficulty] || DEFAULT_DIFFICULTY
        @expiry = args[:expiry] || DEFAULT_EXPIRY
        @width = (args[:width] || DEFAULT_WIDTH).to_i
        @action_label = args[:action_label] || DEFAULT_ACTION_LABEL
        @reload_label = args[:reload_label] || DEFAULT_RELOAD_LABEL
        @reload_max = args[:reload_max] || DEFAULT_RELOAD_MAX
        @reload_count = args[:reload_count] || DEFAULT_RELOAD_COUNT
        @reload = args[:reload] == false ? false : allow_reload?
        @css = (args[:css] != false)
        @puzzle_font = args[:puzzle_font] || DEFAULT_PUZZLE_FONT
      end

      private

      attr_reader(
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

      def call
        arguments_check

        Html.call(
          id: id,
          puzzle: puzzle,
          width: width,
          action_label: action_label,
          truth_payload: truth_payload,
          reload_payload: reload_payload,
          reload_label: reload_label,
          reload: reload,
          css: css
        )
      end

      def puzzle
        Puzzle.call(truth, difficulty, puzzle_font)
      end

      def truth
        @truth ||= Truth.call(difficulty)
      end

      def truth_payload
        Encryptor.encrypt(truth: truth, timestamp: Time.current + expiry)
      end

      def reload_payload
        return unless reload

        Encryptor.encrypt(
          id: id,
          difficulty: difficulty,
          expiry: expiry,
          width: width,
          action_label: action_label,
          reload_label: reload_label,
          reload_max: reload_max,
          reload_count: reload_count,
          reload: reload,
          css: css,
          puzzle_font: puzzle_font
        )
      end

      def allow_reload?
        @reload_count <= @reload_max
      end

      def arguments_check
        unless difficulty.is_a?(Integer) && difficulty.between?(1, 5)
          raise Error, "'difficulty' must be an Integer value between 1 and 5."
        end

        return if expiry.is_a?(ActiveSupport::Duration)

        raise Error, "'expiry' must be an ActiveSupport::Duration object."
      end
    end
  end
end
