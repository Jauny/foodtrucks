require 'bundler/setup'

class App < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/trucks' do
    trucks = HTTParty.get("http://data.sfgov.org/resource/rqzj-sfat.json")
    trucks.select! { |truck| !!truck["location"] && truck["status"] == "APPROVED" }

    trucks[0..29].to_json
  end

end
