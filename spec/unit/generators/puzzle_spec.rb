# frozen_string_literal: true

RSpec.describe Captchah::Generators::Puzzle do
  subject { described_class }

  it 'returns a base64 image' do
    expect(subject.call('ABC', 1, 'font')).to match(/data:image\/jpeg;base64,/)
  end
end
