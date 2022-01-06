require 'rails_helper'
require 'net/http'
describe "Ping API" do
  it 'sends a PING messages' do
    response = Net::HTTP.get_response(URI('http://localhost:3000/api/v1/ping'))
    json = JSON.parse(response.body)
    expect(json['success']).to eq(true)
  end
end
