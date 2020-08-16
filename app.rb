require 'sinatra'
require 'sinatra/activerecord'
require 'byebug'
require 'sinatra/json'
require 'logger'

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }
Dir["#{current_dir}/models/entities/*.rb"].each { |file| require file }
Dir["#{current_dir}/models/constants/*.rb"].each { |file| require file }


post '/' do
  url_string = params[:url]
  return throw_unprocessable(Constants::ValidationErrors::INVALID_URL) unless url_string.present? && is_valid_url?(url_string)

  token_string = params[:token]
  return error_response(Constants::ValidationErrors::TOKEN_NOT_AVAILABLE) if Url.where(token: token_string).count.positive?

  expiry = params[:expiry_minutes]
  expiry = expiry.to_i if expiry.present?

  token_string = Digest::SHA1.hexdigest(Time.now.to_f.to_s)[0,6] unless token_string.present?

  if expiry
    url = Url.create(url: url_string, token: token_string, expiry: Time.now + expiry.minutes)
  else
    url = Url.create(url: url_string, token: token_string)
  end

  data = {}
  data[:url] = url
  data[:short_url] = ENV['URL_SHORTENER_SERVICE_DOMAIN'].to_s + "/#{token_string}"
  response_data(data, 'Url Shortened', 200)
end

get '/:token' do
  token_string = params[:token]
  url = Url.find_by(token: token_string)
  return erb :index unless url
  redirect url.url
end

def response_data(data, message, status, error:nil, disabled:false, update:false, external_rating: nil, params: {})
  result = Hash.new
  result[:data] = data
  result[:message] = message
  result[:status] = status
  result[:error] = error
  result[:disabled] = disabled
  result[:update] = update
  result[:external_rating] = external_rating
  status status
  json result
end

def throw_unprocessable(error_args)
  error = Entities::Error.new(error_args[0], error_args[1])
  return response_data(nil, "Insufficient parameters or Incorrect parameters", 422, error: error)
end

def error_response(error_args)
  return response_data(nil, error_args[1], 200, error: Entities::Error.new(error_args[0], error_args[1]))
end

def error_response_bad_request(error_args)
  return response_data(nil, error_args[1], 400, error: Entities::Error.new(error_args[0], error_args[1]))
end

def is_valid_url? url
  uri = URI.parse url
  uri.kind_of? URI::HTTP
rescue URI::InvalidURIError
  false
end
