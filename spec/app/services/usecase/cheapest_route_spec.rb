# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Services::Usecase::CheapestRoute do
  let(:handler) { double(:handler) }
  let(:exchange_handler) { double(:exchange_handler) }
  let(:params) { { origin: origin, destination: destination } }
  let(:origin) { 'CNHSA' }
  let(:destination) { 'QWERT' }

  describe '#execute' do
    subject { described_class.execute(handler, exchange_handler, params) }

    context 'cheapest route' do
      it 'expect to trigger routes' do
        expect(handler).to receive(:routes).with(origin, destination).and_return([])
        subject
      end
    end
  end
end
