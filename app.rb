require 'sinatra/base'
require 'bundler/setup'
require 'sprockets'
require 'sprockets-helpers'

class App < Sinatra::Base
  set :assets, Sprockets::Environment.new(root)

  configure do
    assets.append_path File.join(root, 'assets', 'css')
    assets.append_path File.join(root, 'assets', 'js')
    assets.append_path File.join(root, 'assets', 'images')

    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = '/assets'
      config.digest      = true
    end
    end

    helpers do
      include Sprockets::Helpers
    end

  get '/' do
    haml :index
  end

  get '/trucks' do
    # get trucks from api
    trucks = get_trucks

    # some trucks have no location
    trucks = filter_trucks_without_loc(trucks)

    # uniqify trucks
    trucks = uniqify_trucks(trucks)

    trucks.to_json
  end

  private
  def get_trucks
    HTTParty.get("http://data.sfgov.org/resource/fi3h-6q7h.json")
  end

  def filter_trucks_without_loc(trucks)
    trucks.select! { |truck| !!truck["location"] }
  end

  def uniqify_trucks(trucks)
    trucks_permits = Hash.new
    trucks.each do |truck|
      if trucks_permits[truck["applicant"]]
        trucks_permits[truck["applicant"]]["location"] << truck["location"]
      else
        trucks_permits[truck["applicant"]] = truck
        trucks_permits[truck["applicant"]]["location"] = [trucks_permits[truck["applicant"]]["location"]]
      end
    end

    trucks_permits.values
  end

end
