# encoding: UTF-8

require 'sinatra/base'
require 'aws/s3'
require 'uri'

class Storage < Sinatra::Base
  include AWS::S3
  AWS::S3::DEFAULT_HOST.replace ""
  s3_bucket_name = ''

  head '/' do
    [200, 'OK']
  end

  get '/*' do
    s3_resource = URI.unescape(params[:splat].first).force_encoding('utf-8')
    Base.establish_connection!(
      access_key_id:     '',
      secret_access_key: ''
    )

    begin
      s3_object = S3Object.value(s3_resource, s3_bucket_name).response
    rescue => e
      # TODO LOG
      make_response e.response
    else
      make_response s3_object
    end

  end

  put '/*' do
    Base.establish_connection!(
      access_key_id:     '',
      secret_access_key: ''
    )
    s3_resource = URI.unescape(params[:splat].first).force_encoding('utf-8')

    begin
      s3_response = S3Object.store "#{s3_resource}", request.body.read, s3_bucket_name
    rescue => e
      #TODO LOG
      make_response e
    else
      make_response s3_response
    end
  end

  delete '/*' do
    Base.establish_connection!(
      access_key_id:     '',
      secret_access_key: ''
    )
    s3_resource = URI.unescape(params[:splat].first).force_encoding('utf-8')

    begin
      is_delete = S3Object.delete("#{s3_resource}", s3_bucket_name)
    rescue => e
      #TODO LOG
      [500, 'S3 Error']
    else
      if is_delete
        [200, 'OK']
      else
        [404, 'Not Found']
      end
    end
  end

  private
  def make_response(res)
    status       res.code
    content_type res.headers["content-type"]
    body         res.body
  end

end


