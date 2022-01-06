require 'rails_helper'
require 'net/http'
describe "Posts API" do
  it 'send request' do
    response = Net::HTTP.get_response(URI('http://localhost:3000/api/v1/posts?tags=tech,health,history,science,culture,startups,design,politics&sortBy=id&direction=asc'))
    json = JSON.parse(response.body)
    expect(json['posts'].length).to eq(96)
  end
end
