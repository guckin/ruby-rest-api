require_relative '../lib/boat_n_slip'
require_relative '../lib/boat_n_slip/entities/mongo_collections'
require_relative '../lib/server/server'

require 'rspec'
require 'net/http'

BoatNSlip.configure do |config|
  config.mongo_connection = 'mongodb://127.0.0.1:27017'
  config.db_name = 'boatnslip'
  config.log = false
  config.server_url = 'http://localhost:4567'
end

def boat_data
  {
    # id: Time.now.to_s,
    name: 'test',
    type: 'test',
    length: '20',
    # at_sea: 'false'
  }
end

def slip_data
  {
    # id: Time.now.to_s,
    number: '1',
    # current_boat: 'test',
    arrival_date: 'test',
    departure_history: 'test'
  }
end

def slip_patch_data
  {
    number: '2'
  }
end

def boat_patch_data
  {
    name: 'poop'
  }
end

def slip_put_data
  slip_data.merge(slip_patch_data)
end

def boat_put_data
  boat_data.merge(boat_patch_data)
end

def get(path)
  sleep 0.5
  uri = URI("#{BoatNSlip.config.server_url}#{path}")
  JSON.parse(Net::HTTP.get(uri))
end

def post(path, data)
  sleep 0.5
  uri = URI("#{BoatNSlip.config.server_url}#{path}")
  JSON.parse(Net::HTTP.post_form(uri, data).body)
end

def delete(path)
  sleep 0.5
  uri = URI("#{BoatNSlip.config.server_url}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Delete.new(uri.path)
  http.request(req)
end

def patch(path, data)
  sleep 0.5
  uri = URI("#{BoatNSlip.config.server_url}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Patch.new(path)
  req.set_form_data(data)
  JSON.parse http.request(req).body
end

def put(path, data)
  sleep 0.5
  uri = URI("#{BoatNSlip.config.server_url}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Put.new(path)
  req.set_form_data(data)
  JSON.parse http.request(req).body
end

def put_no_body(path, data)
  sleep 0.5
  uri = URI("#{BoatNSlip.config.server_url}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Put.new(path)
  req.set_form_data(data)
  http.request(req)
end


include BoatNSlip::Collections

def delete_all(collection)
  send(collection).delete_many({})
end


