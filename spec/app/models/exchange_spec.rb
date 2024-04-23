# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Exchange do
  let(:rates) do
    {
      '2024-04-10': {
        'usd': 1.1138,
        'jpy': 130.85
      }
    }
  end
  describe '#seed' do
    context 'seed rates' do
      it 'should create rate' do
        described_class.seed(rates)
        got_rates = described_class.rates
        expect(got_rates.count).to eq(2)
        expect(got_rates.map(&:currency)).to match_array(['USD', 'JPY'])
        expect(got_rates.map(&:rate)).to match_array([1.1138, 130.85])
      end
    end
  end

  describe '#rate' do
    let(:date) { '2024-04-10' }
    let(:currency) { 'USD' }
    subject { described_class.rate(date, currency) }
    context 'given date & currency' do
      it { is_expected.to be(1.1138) }
    end

    context 'rate not found' do
      let(:date) { '2024-04-29' }
      it { is_expected.to be(Float::INFINITY) }
    end
  end
end
