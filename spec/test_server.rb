require_relative '../lib/server/server'

class Server

set :bind, '0.0.0.0'
set :port, 8080

end

Server.run!
