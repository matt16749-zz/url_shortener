require 'base64'

class UrlsController < ApplicationController
  def shortened
    url = Url.find_by("shortened = ?", params['shortened'])

    if url
      redirect_to url.original
    else
      render plain: "Couldn't find original url for shortened url #{params['shortened']}"
    end
  end

  def links
    if UrlValidator.new(params).validate
      @url = Url.new
      @url.original = params['original']
      @url.shortened = Base64.urlsafe_encode64(params['original'])
      @url.save

      render json: {
        original: @url.original,
        shortened: @url.shortened
      }.to_json
    else
      render status: :unprocessable_entity, json: {
        errors: params['errors']
      }.to_json
    end
  end
end
