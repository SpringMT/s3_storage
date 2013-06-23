#!/usr/bin/env ruby
# encoding: UTF-8

require 'rspec'
require 'rack/test'
require 'sinatra'
require './lib/s3_storage'

set :environment, :test

RSpec.configure do |conf|
    conf.include Rack::Test::Methods
end

