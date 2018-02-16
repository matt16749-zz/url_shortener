require 'base64'
require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe "all GET requests" do
    it "routes to urls#shortened" do
      expect(get: '/foo/bar').to route_to(
        controller: 'urls',
        action: 'shortened',
        shortened: 'foo/bar'
      )
    end
  end

  describe "POST #links" do
    context "with valid params" do
      it 'creates a shortened url' do
        params = { original: 'http://google.com' }
        shortened_url = Base64.urlsafe_encode64(params[:original])

        post :links, params: params

        expected = {
          'original' => 'http://google.com',
          'shortened' => shortened_url
        }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(expected)
      end
    end

    context "with invalid params" do
      context 'missing required param' do
        it 'returns an error regarding missing required params' do
          params = {}

          post :links, params: params

          expect(response).to have_http_status(422)
          response_errors = JSON.parse(response.body)['errors']
          expected_error = "Missing required params: [\"original\"]"
          expect(response_errors.include?(expected_error)).to be(true)
        end
      end

      context 'additional params' do
        it 'returns an error regarding additional params' do
          params = { additional_param: '' }

          post :links, params: params

          expect(response).to have_http_status(422)
          response_errors = JSON.parse(response.body)['errors']
          expected_error = "Extra params: [\"additional_param\"]"
          expect(response_errors.include?(expected_error)).to be(true)
        end
      end

      context 'required params' do
        context 'original' do
          context 'is not a valid http url' do
            it 'returns an error regarding invalid http url' do
              params = { original: 'invalid_url' }

              post :links, params: params

              expect(response).to have_http_status(422)
              response_errors = JSON.parse(response.body)['errors']
              expected_error = 'invalid_url is not a valid url'
              expect(response_errors.include?(expected_error)).to be(true)
            end
          end

          context 'is empty string' do
            it 'returns an error regarding params["original"] not being blank' do
              params = { original: '' }

              post :links, params: params

              expect(response).to have_http_status(422)
              response_errors = JSON.parse(response.body)['errors']
              expected_error = 'params["original"] cannot be blank'
              expect(response_errors.include?(expected_error)).to be(true)
            end
          end

          context 'is null' do
            it 'returns an error regarding params["original"] not being blank' do
              params = { original: nil }

              post :links, params: params

              expect(response).to have_http_status(422)
              response_errors = JSON.parse(response.body)['errors']
              expected_error = 'params["original"] cannot be blank'
              expect(response_errors.include?(expected_error)).to be(true)
            end
          end
        end
      end
    end
  end
end
