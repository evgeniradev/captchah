# frozen_string_literal: true

require 'active_support/core_ext/string/output_safety'
require 'captchah/generators/html'

RSpec.describe Captchah::Generators::Html do
  subject { described_class }

  let(:args) { all_args.slice(*Captchah::Generators::Html::ATTR_NAMES) }

  it 'generates full html' do
    expect(subject.call(args)).to eq(expectation('full_html'))
  end

  it 'generates html with no reload option' do
    args[:reload] = false

    expect(subject.call(args)).to eq(expectation('html_with_no_reload_option'))
  end

  it 'generates html with no css' do
    args[:css] = false

    expect(subject.call(args)).to eq(expectation('html_with_no_css'))
  end

  def expectation(filename)
    path = File.join(File.dirname(__FILE__), '../../', 'fixtures', 'html')
    File.read(File.join(path, "#{filename}.html"))
  end
end
