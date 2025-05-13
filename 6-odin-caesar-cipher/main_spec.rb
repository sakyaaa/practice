# frozen_string_literal: true

require_relative 'main'

RSpec.describe '#caesar_cipher' do
  it 'shifts letters by the given number' do
    expect(caesar_cipher('abc', 1)).to eq('zab')
    expect(caesar_cipher('xyz', 3)).to eq('uvw')
  end

  it 'maintains case sensitivity' do
    expect(caesar_cipher('AbC', 1)).to eq('ZaB')
    expect(caesar_cipher('XyZ', 3)).to eq('UvW')
  end

  it 'handles spaces and special characters' do
    expect(caesar_cipher('Hello, World!', 1)).to eq('Gdkkn, Vnqkc!')
    expect(caesar_cipher('What a string!', 5)).to eq('Rcvo v nomdib!')
  end

  it 'handles large shift values' do
    expect(caesar_cipher('abc', 27)).to eq('zab')
    expect(caesar_cipher('abc', 52)).to eq('abc')
  end

  it 'handles empty strings' do
    expect(caesar_cipher('', 5)).to eq('')
  end

  it 'handles strings with no letters' do
    expect(caesar_cipher('123!@#', 5)).to eq('123!@#')
  end
end
