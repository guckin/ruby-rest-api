require_relative 'boat_n_slip/entities/boats'
require_relative 'boat_n_slip/entities/slips'
require_relative 'boat_n_slip/open_object'
require_relative 'server/server'
require 'mongo'

module BoatNSlip

  def self.config(defaults = {})
    @config ||= OpenObject.new(defaults)
  end

  def self.configure
    yield config if block_given?
  end

  def self.boats
    @boats ||= Boats.new
  end

  def self.slips
    @slips ||= Slips.new
  end

  def self.server
    @server ||= Server.new
  end

end