# frozen_string_literal: true

module Captchah
  module Generators
    class Puzzle
      def self.call(*args)
        new(*args).send(:call)
      end

      def initialize(truth, difficulty, font)
        @truth = truth
        @difficulty = difficulty
        @font = font
        @color1 = '44,44,44'
        @color2 = '235,235,235'
      end

      private

      attr_reader :truth, :difficulty, :font, :color1, :color2

      def call
        image.combine_options do |c|
          c.font(font)
          c.pointsize(23)
          c.blur("0x#{difficulty < 4 ? 3 : 4}")
          c.fill(rgba(color2, opacity))
          c.distort(
            'Shepards',
            "#{rand(-108..0)},0 " \
            "0,#{rand(-108..0)} " \
            "#{rand(0..108)},0 " \
            "#{rand(0..108)},8"
          )
          c.draw("text 23,#{rand(21..30)} '#{truth[0..2]}'")
          c.distort(
            'Shepards',
            '30,-50 ' \
            "0,#{rand(-7..-3)} " \
            "#{rand(8..17)},#{rand(2..3)} " \
            "#{difficulty > 2 ? 15 : 10},#{rand(-5..-1)}"
          )
          c.draw("line 0,#{rand(25..35)} 290,30") if difficulty > 1
          c.fill(rgba(color1, opacity))
          c.pointsize(26)
          c.draw("text 82,#{rand(25..40)} '#{truth[3..-1]}'")
          c.draw("line 0,#{rand(10..20)} 400,20") if difficulty > 1

          if difficulty < 3
            c.fill(rgba(color2, 0.1))
            c.draw('circle 0,0 300,0')
          end

          if difficulty > 3
            c.pointsize(20)
            c.fill(rgba(color2, 0.6))
            (difficulty == 5 ? 2 : 1).times do
              c.draw("text #{rand(43..55)},#{rand(18..48)} ',./ -,_'")
            end
            c.fill(rgba(color2, 0.3))
            c.draw("text #{rand(68..75)},#{rand(10..28)} '/,\ ^._  -'")
          end

          if difficulty == 5
            c.pointsize(40)
            c.draw("text #{rand(0..36)},#{rand(38..48)} '. \ _ . -'")
          end

          c.blur("1x#{difficulty - 2}") if difficulty > 2
          c.blur('1x0.1')
          c.quality(100)
        end

        base64_encode
      ensure
        image&.destroy!
      end

      def base64_encode
        image_content = File.open(image.path, &:read)

        "data:image/jpeg;base64,#{Base64.strict_encode64(image_content)}"
      end

      def image
        @image ||=
          begin
            base64_image = Base64Images.puzzle_background
            decoded_image = Base64.strict_decode64(base64_image)
            MiniMagick::Image.read(decoded_image)
          rescue NameError => e
            raise Error, 'Missing MiniMagick.' if e.to_s.include?('MiniMagick')
          end
      end

      def opacity
        @opacity ||= difficulty > 2 ? 0.9 : 1.2
      end

      def rgba(rgb, alpha)
        "rgba(#{rgb},#{alpha})"
      end
    end
  end
end
