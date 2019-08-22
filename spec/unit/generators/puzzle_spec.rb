# frozen_string_literal: true

require 'mini_magick'
require 'captchah/generators/puzzle'

RSpec.describe Captchah::Generators::Puzzle do
  subject { described_class }

  it 'returns a base64 image' do
    expect(subject.call('ABC', 1, 'font')).to match(/data:image\/jpeg;base64,/)
  end

  it 'raises and error if MiniMagick library is missing' do
    Object.send(:remove_const, :MiniMagick)

    expect { subject.call('ABC', 1, 'font') }.to(
      raise_error('Missing MiniMagick.')
    )
  end
end
