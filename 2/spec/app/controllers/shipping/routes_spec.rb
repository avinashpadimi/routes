require 'spec_helper'
require 'pry'

RSpec.describe Api::Controllers::Shipping::Routes do
  def app
    described_class
  end

  def parse_body(body)
    JSON.parse(body, {symbolize_names: true})
  end

  describe "#not_found" do
    subject { get '/not_found' }
    context "given invalid route" do
      it "return 404" do
        subject
        expect(last_response.status).to eq(404)
        resp = parse_body(last_response.body)
        expect(resp.dig(:error,:code)).to eq("route_not_found")
      end
    end
  end

  RSpec.shared_examples "wrong port" do
    it "return error" do
      subject
      expect(last_response.status).to eq(200)
      resp_body = parse_body(last_response.body)
      expect(resp_body[:data]).to be_empty
    end
  end

  describe "#cheapest" do
    let(:origin) { "CNSHA" }
    let(:destination) { "NLRTM" }
    let(:params) do
      {
        origin: origin,
        destination: destination
      }
    end
    subject { get '/cheapest', params: params }

    context "given wrong origin port" do
      let(:origin) {"NO12"}
      include_examples "wrong port"
    end

    context "given wrong destination port" do
      let(:destination) {"NO12"}
      include_examples "wrong port"
    end

    context "given valid origin & destination port" do
      it "return cheapest route" do
        subject
        expect(last_response).to eq(200)
        resp_body = parse_body(last_response.body)
        expected_resp = [{
          origin_port: "CNSHA",
          destination_port: "ESBCN",
          departure_date: "2022-01-29",
          arrival_date: "2022-02-06",
          sailing_code: "ERXQ",
          rate: "261.96",
          rate_currency: "EUR"
        },
        {
          origin_port: "ESBCN",
          destination_port: "NLRTM",
          departure_date: "2022-02-16",
          arrival_date: "2022-02-20",
          sailing_code: "ETRG",
          rate: "69.96",
          rate_currency: "USD"
        }]
        expect(resp_body[:data]).to match_array(expected_resp)
      end
    end
  end

  describe "#cheapest_direct" do
    context "given wrong origin port" do
      include_examples "wrong port"
    end

    context "given wrong destination port" do
      include_examples "wrong port"
    end

    context "given valid origin & destination port" do
      it "return cheapest direct route" do
        subject
        expect(last_response).to eq(200)
        resp_body = parse_body(last_response.body)
        expected_resp = [{
          origin_port: "CNSHA",
          destination_port: "NLRTM",
          departure_date: "2022-02-01",
          arrival_date: "2022-03-01",
          sailing_code: "ABCD",
          rate: "589.30",
          rate_currency: "USD"
        }]
        expect(resp_body[:data]).to match_array(expected_resp)

      end
    end
  end
end
