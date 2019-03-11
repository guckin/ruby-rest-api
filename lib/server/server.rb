require 'sinatra'
require 'json'
require 'pry'
require 'logger'

require_relative '../boat_n_slip'

class Server < Sinatra::Base

  def self.run!
    # TODO: Clean up
    BoatNSlip.configure do |config|
      config.mongo_connection = 'mongodb://127.0.0.1:27017'
      config.db_name = 'boatnslip'
      config.log = false
    end
    super
  end

#set :bind, '0.0.0.0'
#set :port, 8080

  # error 403 do
  #   'Access forbidden'
  # end

  get '/boats/:id' do
    content_type :json
    BoatNSlip.boats.get(params['id']).to_json
  end

  get '/slips/:id' do
    content_type :json
    BoatNSlip.slips.get(params['id']).to_json
  end

  get '/boats' do
    content_type :json
    BoatNSlip.boats.all.to_json
  end

  get '/slips' do
    content_type :json
    BoatNSlip.slips.all.to_json
  end

  get '/slips/:id/boat' do
    content_type :json
    boat = BoatNSlip.slips.get(params['id'])[:current_boat]
    if boat == 'None'
      boat
    else
      BoatNSlip.boats.get(boat).to_json
    end
  end

  post '/boats' do
    content_type :json
    BoatNSlip.boats.post(params).to_json
  end

  post '/slips' do
    content_type :json
    BoatNSlip.slips.post(params).to_json
  end

  delete '/boats/:id' do
    content_type :json
    BoatNSlip.boats.delete(params['id'])
    { 'delete' => 'success' }.to_json
  end

  delete '/slips/:id' do
    content_type :json
    BoatNSlip.slips.delete(params['id']).to_json
  end

  patch '/boats/:id' do
    begin
      content_type :json
      BoatNSlip.boats.patch(params['id'], params).to_json
    rescue NoSlipAvailable
      halt 403
    end
  end

  patch '/slips/:id' do
    content_type :json
    BoatNSlip.slips.patch(params['id'], params).to_json
  end

  put '/boats/:id/to_sea' do
    content_type :json
    BoatNSlip.boats.patch(params['id'], at_sea: true).to_json
  end

  put '/boats/:id/arrive' do
    begin
      content_type :json
      BoatNSlip.boats.patch(params['id'], at_sea: false).to_json
    rescue NoSlipAvailable
      halt 403
    end
  end

  put '/boats/:id' do
    content_type :json
    BoatNSlip.boats.put(params['id'], params).to_json
  end

  put '/slips/:id' do
    content_type :json
    BoatNSlip.slips.put(params['id'], params).to_json
  end

end

