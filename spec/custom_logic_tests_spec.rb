require_relative 'spec_helper'

describe 'Rest implementation - Custom logic' do

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



  context 'Add' do

    it 'All newly created boats should start "At sea" ' do
      id = post('/boats', boat_data)['id']
      result = get("/boats/#{id}")
      expect(result['at_sea']).to eq true
    end

    it 'All newly created slips should be empty' do
      id = post('/slips', slip_data)['id']
      result = get("/slips/#{id}")
      expect(result['current_boat']).to eq 'None'
    end
  end

  context 'delete' do
    it 'Deleting a ship should empty the slip the boat was previously in' do
      slip_id = post('/slips', slip_data)['id']
      boat_id = post('/boats', boat_data)['id']
      patch("/slips/#{slip_id}", current_boat: boat_id)
      delete("/boats/#{boat_id}")
      result = get("/slips/#{slip_id}")
      expect(result['current_boat']).to eq 'None'
    end

    it 'Deleting a pier a boat is currently in should set that boat to be "At sea"' do
      slip_id = post('/slips', slip_data)['id']
      boat_id = post('/boats', boat_data)['id']
      patch("/slips/#{slip_id}", current_boat: boat_id)
      delete("/slips/#{slip_id}")
      result = get("/boats/#{boat_id}")
      expect(result['at_sea']).to eq true
    end
  end

  context 'View' do
    it 'it should be possible, via a url, to view the specific boat currently occupying any slip' do
      slip_id = post('/slips', slip_data)['id']
      boat_id = post('/boats', boat_data)['id']
      patch("/slips/#{slip_id}", current_boat: boat_id)
      result = get("/slips/#{slip_id}/boat")
      expect(result['id']).to eq boat_id
    end
  end

  context 'Setting a boat to be "At sea"' do
    it 'This should cause the previously occupied slip to become empty' do
      slip_id = post('/slips', slip_data)['id']
      boat_id = post('/boats', boat_data)['id']
      patch("/slips/#{slip_id}", current_boat: boat_id)
      patch("/boats/#{boat_id}", at_sea: true)
      result = get("/slips/#{slip_id}")
      expect(result['current_boat']).to eq 'None'
    end

    it 'Setting the ship to be "At sea" and updating the slip status should happen via a single API call' do
      slip_id = post('/slips', slip_data)['id']
      boat_id = post('/boats', boat_data)['id']
      patch("/slips/#{slip_id}", current_boat: boat_id)
      result = put("/boats/#{boat_id}/to_sea", {})
      expect(result['at_sea']).to eq true
    end

  end

  context 'arrival of boat' do
    it 'should handle arrival of a boat' do
      post('/slips', slip_data)['id']
      boat_id = post('/boats', boat_data)['id']
      put("/boats/#{boat_id}/arrive", {})
      result = get("/boats/#{boat_id}")
      expect(result['at_sea']).to eq false
    end

    it 'should return 403 when a slip is not available' do
      delete_all 'slips'
      boat_id = post('/boats', boat_data)['id']
      result = put_no_body("/boats/#{boat_id}/arrive", {})
      expect(result.to_s.include?('Forbidden')).to eq true
    end
  end

  # it 'test: double patch' do
  #   delete_all 'slips'
  #   delete_all 'boats'
  #   data = boat_data
  #   data[:name] = '1'
  #   boat_id_1 = post('/boats', data)['id']
  #   data[:name] = '2'
  #   boat_id_2 = post('/boats', data)['id']
  #   slip_id = post('/slips', slip_data)['id']
  #   update = patch("/slips/#{slip_id}", current_boat: boat_id_1+'fadf')
  #   # update = patch("/slips/#{slip_id}eee", current_boat: boat_id_2)
  #   # result_1 = get("/boats/#{boat_id_1}")
  #   # result_2 = get("/boats/#{boat_id_2}")
  #   # result_2 = get("/boats/asdfsafs")
  #   # expect(result_1['at_sea']).to eq true
  #   # expect(result_2['at_sea']).to eq false
  # end

  # it 'bad id' do

  # end

end