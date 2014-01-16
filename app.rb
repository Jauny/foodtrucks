require 'bundler/setup'

class App < Sinatra::Base

  get '/' do
    @trucks = HTTParty.get("http://data.sfgov.org/resource/rqzj-sfat.json")
    @trucks.select! {|truck| !!truck["location"] && truck["status"] == "APPROVED"}

    haml :index
  end

end
