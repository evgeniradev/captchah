# frozen_string_literal: true

module Captchah
  module Generators
    class Truth
      def self.call(difficulty)
        chrs = []

        (rand(0..1).positive? ? 4 : 5).times do
          up_or_down = rand(0..1).positive? && difficulty > 1 && difficulty != 3
          chr = (up_or_down ? rand(97..122) : rand(65..90)).chr
          chrs << (%w[i j l r].any? { |c| c == chr } ? chr.upcase : chr)
        end

        chrs.join
      end
    end
  end
end
