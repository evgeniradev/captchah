# frozen_string_literal: true

module Captchah
  module Generators
    class Html
      ATTR_NAMES = %i[
        id
        puzzle
        width
        action_label
        truth_payload
        reload_payload
        reload_label
        reload
        css
      ].freeze

      def self.call(*args)
        new(*args).send(:call)
      end

      def initialize(args)
        ATTR_NAMES.each do |attr_name|
          instance_variable_set("@#{attr_name}", args[attr_name])
        end
      end

      private

      attr_reader(*ATTR_NAMES)

      def call
        tags = [
          style_tag,
          action_tag,
          truth_tag,
          guess_tag,
          puzzle_tag,
          reload_animation_tag,
          reload_tag,
          javascript_tag
        ].join

        "<div id='#{container_id}' class='captchah'>#{tags}</div>"
          .gsub(/(\s\s)*/, '')
          .html_safe
      end

      def style_tag
        return unless css

        "<style type='text/css'>
          ##{container_id} {
            background-color: #f9f9f9;
            border-radius: 2px;
            border: 1px solid #d3d3d3;
            color: black;
            font-family: 'Verdana';
            font-size: 11px;
            letter-spacing: 0;
            max-width: #{width}px;
            padding: 10px;
          }

          ##{container_id} .captchah-guess {
            background-color: white;
            border-radius: 2px;
            border: 1px solid #c1c1c1;
            font-size: 18px !important;
            height: 45px;
            line-height: 0;
            margin: 5px 0;
            max-width: #{width - 12}px;
            min-width: 0;
            outline: none;
            padding: 0 5px;
            width: 100%;
          }

          ##{container_id} .captchah-reload-animation {
            margin-top: 11px;
            transform: translateY(-50%);
          }

          ##{container_id} .captchah-puzzle,
          ##{container_id} .captchah-guess {
            display: block;
          }

          ##{container_id} .captchah-action {
            margin: 0;
            padding: 0;
          }

          ##{container_id} .captchah-puzzle {
            margin: 0
            padding: 0;
            width: 100%;
          }

          ##{container_id} .captchah-reload {
            color: #5e5e5e;
            cursor: pointer;
            display: inline-block;
            line-height: 1;
            margin-top: 5px;
            text-decoration: none;
            transition: 0.3s;
          }

          ##{container_id} .captchah-reload:hover {
            color: black;
          }
        </style>"
      end

      def action_tag
        "<p class='captchah-action'>#{action_label}</p>"
      end

      def truth_tag
        '<input ' \
        "type='hidden' " \
        "name='captchah[truth]' " \
        "value='#{truth_payload}' " \
        "class='captchah-truth'>"
      end

      def guess_tag
        '<input ' \
        "type='text' " \
        "autocomplete='off' " \
        "name='captchah[guess]' " \
        "class='captchah-guess'>"
      end

      def puzzle_tag
        '<img ' \
        "src='#{puzzle}' " \
        "class='captchah-puzzle'>"
      end

      def reload_animation_tag
        '<img ' \
        "src='#{"data:image/gif;base64,#{Base64Images.loader}"}' " \
        "style='display: none;' " \
        "class='captchah-reload-animation'>"
      end

      def reload_tag
        return unless reload

        '<span ' \
        "onclick='captchah(this)' " \
        "data-payload='#{reload_payload}' " \
        "class='captchah-reload'>" \
          "#{reload_label}" \
        '</span>'
      end

      def javascript_tag
        return unless reload

        "<script type='text/javascript'>
          var captchah = function(reload) {
            var captchahLoaderAnimation = function(el_show, el_hide){
              el_hide.style.display='none';
              el_show.style.display='inline-block';
            };

            captchahLoaderAnimation(reload.previousSibling, reload);

            var xhr = new XMLHttpRequest();
            xhr.open('POST', '/captchah');
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            xhr.onload = function() {
              if (xhr.status === 200) {
                reload.parentNode.outerHTML = xhr.responseText;
              }
              else if (xhr.status !== 200) {
                console.log('Error: Unable to change captcha.');
                captchahLoaderAnimation(reload, reload.previousSibling);
              }
            };
            xhr.send(JSON.stringify({captchah: reload.dataset.payload}));
          };
        </script>"
      end

      def container_id
        @container_id ||= "captchah-#{id}"
      end
    end
  end
end
