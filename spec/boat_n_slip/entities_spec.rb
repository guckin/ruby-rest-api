require_relative '../spec_helper'

%w[boat slip].each do |type|
  klass = Object.const_get(type.capitalize + 's')
  describe klass do
    before :each do
      @instance = klass.new
    end
    context 'methods respond' do
      %w[post delete get all filter collection].each do |method|
        it "should respond to #{method}" do
          expect(@instance.respond_to?(method, true)).to eq true
        end
        it 'should ignore invalid data' do
          #TODO:
        end
      end
    end
    context 'method operations' do
      before :each do
        @data = send("#{type}_data")
        @id = @instance.post(@data)[:id]
      end
      after :each do
        delete_all(type + 's')
      end
      it "should #post a #{type}" do
        expect(@instance.get(@id)).to be_truthy
      end
      it "should #delete a #{type}" do
        @instance.delete(@id)
        expect(@instance.get(@id)).to be_nil
      end
      it "should #get a #{type}" do
        expect(@instance.get(@id)).to be_truthy
      end
      it "should #get all #{type}" do
        expect(@instance.all).to be_truthy
      end
      it "should #patch a #{type}" do
        patch_data = send("#{type}_patch_data")
        @instance.patch(@id, patch_data)
        expect(@instance.get(@id) > patch_data).to eq true
      end
      it "should #put a #{type}" do
        put_data = send("#{type}_put_data")
        @instance.put(@id, put_data)
        expect(@instance.get(@id) > put_data).to eq true
      end
      it 'should filter a hash' do
        data = {
          test: 'test'
        }.merge(@data)
        result = @instance.send :filter, data
        expect(result).to eq @data
      end
      it "it should hold the #{type + 's'} collection" do
        expect(@instance.send(:collection).class).to eq Mongo::Collection
      end
    end
  end
end
