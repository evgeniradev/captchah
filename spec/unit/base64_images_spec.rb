# frozen_string_literal: true

require 'captchah/base64_images'

RSpec.describe Captchah::Base64Images do
  subject { described_class }

  it 'ensures loader image is of correct length' do
    expect(subject.loader.length).to be(1556)
  end

  it 'ensures puzzle_background image is of correct length' do
    expect(subject.puzzle_background.length).to be(9868)
  end
end
