# frozen_string_literal: true

module AllArgs
  ALL_ARGS_NAMES = %i[
    id
    difficulty
    expiry
    width
    puzzle
    truth
    action_label
    truth_payload
    reload_payload
    reload_label
    reload_max
    reload_count
    reload
    css
    puzzle_font
  ].freeze

  def all_args
    @all_args ||= begin
      ALL_ARGS_NAMES.map do |attr_name|
        value =
          case attr_name
          when :difficulty
            1
          when :expiry
            5.minutes
          when :width
            160
          when :reload_count
            2
          when :reload_max
            3
          when :reload, :css
            true
          else
            attr_name.to_s
          end

        [attr_name, value]
      end.to_h
    end
  end
end
