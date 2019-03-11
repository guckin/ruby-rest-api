require_relative '../spec_helper'

describe BoatNSlip::Collections do

  class Test
    include BoatNSlip::Collections
    extend BoatNSlip::Collections
  end

  context 'Client' do
    it 'should return a mongo client' do
      expect(Test.new.client.class).to be(Mongo::Client)
    end
  end

  context 'Collections' do

    def slips
      Test.slips
    end

    def boats
      Test.new.boats
    end

    before :each do
      @doc = {
        id: Time.now.to_s,
        name: 'test'
      }
    end

    %i[slips boats].each do |type|
      it "should insert #{type}" do
        begin
          send(type).insert_one(@doc)
          result = send(type).find(id: @doc[:id]).first
        ensure
          send(type).delete_many(id: @doc[:id])
        end
        expect(result).to be_truthy
      end

      it "should find #{type}" do
        begin
          send(type).insert_one(@doc)
          result = send(type).find(id: @doc[:id])
        ensure
          send(type).delete_many(id: @doc[:id])
        end
        expect(result).to be_truthy
      end

      it "should delete #{type}" do
        begin
          send(type).insert_one(@doc)
          send(type).delete_one(id: @doc[:id])
          result = send(type).find(id: @doc[:id])
        ensure
          send(type).delete_many(id: @doc[:id])
        end
        expect(result.to_a.empty?).to eq true
      end

      it "should update #{type}" do
        begin
          send(type).insert_one(@doc)
          send(type).update_one({ id: @doc[:id] },
                                { '$set' => { name: 'updated' } })
          result = send(type).find(id: @doc[:id]).first
        ensure
          send(type).delete_many(id: @doc[:id])
        end
        expect(result[:name]).to eq 'updated'
      end

    end

  end
end