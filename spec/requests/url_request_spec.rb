require 'base64'
require "rails_helper"

RSpec.describe "Url Requests", :type => :request do
  describe 'POST request to get shortened url and following url' do
    it "redirects to original url" do
      original_url = 'http://www.google.com'

      post "/links?original=#{original_url}"

      expect(response).to have_http_status(200)
      post_response = JSON.parse(response.body)
      shortened_url =
        /(localhost:3000\/)(.+)/.match(post_response['shortened'])[2]

      get "/#{shortened_url}"

      expect(response).to redirect_to(original_url)
      expect(response).to have_http_status(302)
    end

    context 'GET shortened url not found' do
      it 'renders an error text' do
        shortened_url = 'shortened_url'

        get "/#{shortened_url}"

        expected =
          "Couldn't find original url for shortened url #{shortened_url}"
        expect(response).to have_http_status(200)
        expect(response.body).to eq(expected)
      end
    end
  end
end
