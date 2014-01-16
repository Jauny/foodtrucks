require 'bundler/setup'

class UberApp < Sinatra::Base

  get '/' do
    @trucks = HTTParty.get("http://data.sfgov.org/resource/rqzj-sfat.json")
    @trucks.select! {|truck| !!truck["location"] && truck["status"] == "APPROVED"}

    haml :index
  end

end
