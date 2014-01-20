require 'rubygems'
require 'bundler'
require 'httparty'
require 'sprockets'
require './app'

Bundler.require

map '/assets' do
  run App.assets
end

run App
