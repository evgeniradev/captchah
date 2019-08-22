# frozen_string_literal: true

require 'captchah/generators/truth'

RSpec.describe Captchah::Generators::Truth do
  subject { described_class }

  it 'returns at least 4 letters' do
    expect(subject.call(1).length).to be >= 4
  end

  [1, 3].each do |difficulty|
    it "returns only capital letters if difficulty == #{difficulty}" do
      result = subject.call(difficulty)

      expect(result).to eq(result.upcase)
    end
  end
end
