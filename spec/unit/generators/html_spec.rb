# frozen_string_literal: true

RSpec.describe Captchah::Generators::Html do
  subject { described_class }

  let(:args) { all_args.slice(*Captchah::Generators::Html::ATTR_NAMES) }

  it 'generates full html' do
    filename = 'full_html'
    path = File.join(File.dirname(__FILE__), '../../', 'fixtures', 'html')
    file = File.join(path, "#{filename}.html")
    File.write(file, subject.call(args))

    expect(subject.call(args)).to eq(expectation('full_html'))
  end

  it 'generates html with no reload option' do
    args[:reload] = false

    filename = 'html_with_no_reload_option'
    path = File.join(File.dirname(__FILE__), '../../', 'fixtures', 'html')
    file = File.join(path, "#{filename}.html")
    File.write(file, subject.call(args))

    expect(subject.call(args)).to eq(expectation('html_with_no_reload_option'))
  end

  it 'generates html with no css' do
    args[:css] = false

    filename = 'html_with_no_css'
    path = File.join(File.dirname(__FILE__), '../../', 'fixtures', 'html')
    file = File.join(path, "#{filename}.html")
    File.write(file, subject.call(args))

    expect(subject.call(args)).to eq(expectation('html_with_no_css'))
  end

  def expectation(filename)
    path = File.join(File.dirname(__FILE__), '../../', 'fixtures', 'html')
    File.read(File.join(path, "#{filename}.html"))
  end
end
