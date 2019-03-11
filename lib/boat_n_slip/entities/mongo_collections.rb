require_relative '../../boat_n_slip'
module BoatNSlip
  module Collections

    def slips
      client[:slips]
    end

    def boats
      client[:boats]
    end

    def slip_number
      client[:slip_number]
    end

    def client
      @client ||= begin
        Mongo::Logger.logger.level = Logger::FATAL unless BoatNSlip.config.log
        Mongo::Client.new(
          BoatNSlip.config.mongo_connection,
          database: BoatNSlip.config.db_name
        )
      end
    end

  end
end