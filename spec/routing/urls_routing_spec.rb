require 'rails_helper'

RSpec.describe UrlsController, type: :routing do
  describe 'routing' do
    describe 'any GET request' do
      it 'routes to urls#shortened' do
        shortened_url = 'shortened_url'
        expect(:get => shortened_url).
          to route_to('urls#shortened', shortened: shortened_url)
      end
    end

    it 'routes to urls#links' do
      expect(:post => '/links').to route_to('urls#links')
    end
  end
end
