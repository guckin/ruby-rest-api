require_relative 'mongo_collections'
require 'date'

# base class for boat and slip
class Entities
  include BoatNSlip::Collections

  def post(data)
    # generate id. this is milliseconds since epoch
    data[:id] = DateTime.now.strftime('%Q')
    return false unless data.keys.to_set == self.class::ATTRIBUTES.to_set
    collection.insert_one data
    get(data[:id])
  end

  # TODO: need to handle when the entity does not exists
  def delete(id)
    return { service: 'bad id' } unless id_exists? id
    collection.delete_one id: id
  end

  def get(id)
    filter(parse_find(collection.find(id: id)).first)
  end

  def patch(id, data)
    data[:id] = id
    patch_data = { '$set' => data }
    collection.update_one({ id: id }, patch_data)
    get(id)
  end

  def put(id, data)
    return { service: 'bad id' } unless id_exists? id
    data[:id] = id
    return false unless data.keys.to_set == self.class::ATTRIBUTES.to_set
    collection.update_one({ id: id }, data)
    get(id)
  end

  def all
    parse_find(collection.find({}))
  end

  def delete_all
    collection.delete_many({})
  end

  def available_slip
    slips.find(current_boat: 'None').first
  end

  def id_exists?(id)
    true if slips.find(id: id).first || boats.find(id: id).first
  end

  private

  def boolean?(value)
    value = value.downcase
    value == 'false' || value == 'true'
  end

  def collection
    @collection ||= send self.class.to_s.downcase
  end

  def filter(hash)
    return hash if hash.nil?
    hash = hash.keys.map(&:to_sym).zip(hash.values).to_h
    ret = {}
    self.class::ATTRIBUTES.each do |attribute|
      # hash[attribute] = hash[attribute].to_bool if boolean?(hash[attribute])
      ret[attribute] = hash[attribute] unless hash[attribute].nil?
    end
    ret
  end

  def parse_find(obj)
    obj.map do |doc|
      doc.delete('_id')
      doc
    end
  end

end