require 'base64'

google_url = 'http://www.google.com'
Url.create!(original: google_url, shortened: Base64.urlsafe_encode64(google_url))
