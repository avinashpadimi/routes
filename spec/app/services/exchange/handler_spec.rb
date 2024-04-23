# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Services::Exchange::Handler do
  def handler
    described_class.new
  end

  before(:all) { seed(ROUTES_DATA) }
  after(:all) { clear }

  describe '#in_euros' do
    let(:date) { '2022-01-29' }
    let(:currency) { 'EUR' }
    let(:amount) { 25.5 }
    subject { handler.in_euros(date, currency, amount) }
    context 'given euro and amount' do
      it { is_expected.to be(amount) }
    end

    context 'given usd and amount' do
      let(:currency) { 'USD' }
      it { is_expected.to be(22.895) }
    end

    context 'given jpy and amount' do
      let(:currency) { 'JPY' }
      it { is_expected.to be(0.195) }
    end
  end
end
