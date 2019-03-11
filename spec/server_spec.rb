require_relative 'spec_helper'
require 'json'

describe 'server' do

  before :all do
    @thread = Thread.new do
      Server.run!
    end
    sleep 1
  end

  after :all do
    Server.stop!
    @thread.join
  end

  %w[boat slip].each do |type|
    context 'operations' do

      it "should GET a #{type}" do
        id = post("/#{type}s", send("#{type}_data"))['id']
        result = get("/#{type}s/#{id}")
        expect(result['id']).to eq id
      end

      it "should GET all #{type}s" do
        ids = []
        2.times { ids << post("/#{type}s", send("#{type}_data"))['id'] }
        result = get("/#{type}s")
        expect((ids - result.map { |e| e['id'] }).empty?).to eq true
      end

      it "should POST a #{type}" do
        result = post("/#{type}s", send("#{type}_data"))
        expect(result).to be_truthy
      end

      it "should DELETE a #{type}" do
        id = post("/#{type}s", send("#{type}_data"))['id']
        path = "/#{type}s/#{id}"
        delete(path)
        result = get(path)
        expect(result.nil?).to eq true
      end

      it "should PATCH a #{type}" do
        id = post("/#{type}s", send("#{type}_data"))['id']
        patch_data = send "#{type}_patch_data"
        patch("/#{type}s/#{id}", patch_data)
        result = get("/#{type}s/#{id}")
        result = result.keys.map(&:to_sym).zip(result.values).to_h
        expect(result > patch_data).to eq true
      end

      it "should PUT a #{type}" do
        id = post("/#{type}s", send("#{type}_data"))['id']
        put_data = send "#{type}_put_data"
        put("/#{type}s/#{id}", put_data)
        result = get("/#{type}s/#{id}")
        result = result.keys.map(&:to_sym).zip(result.values).to_h
        expect(result > put_data).to eq true
      end

    end
  end
end