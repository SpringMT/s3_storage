#!/usr/bin/env ruby
# encoding: UTF-8

require File.dirname(__FILE__) + '/spec_helper'
require 'ap'

describe S3Storage::Storage do

  def app
    S3Storage::Storage
  end

  before do
    @headers       = {'content-type' => 'text/plain', 'date' => Time.now}
    @response      = FakeResponse.new()
    @base_response = Base::Response.new(@response)
    Base.stub(:establish_connection!).and_return(true)
    S3Object.stub_chain(:value, :response).and_return()
  end

  it :head do
    head '/'
    last_response.should be_ok
    last_response.body.should eq 'OK'
  end

  it :get do
    
  end
  #it "says hello to a person" do
  #  get '/', :name => 'Simon'
  #  last_response.body.should include('Simon')
  #end
end


