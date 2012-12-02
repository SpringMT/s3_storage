# encoding: UTF-8

require 'sinatra/base'
require 'aws/s3'
require 'uri'
require 'yaml'

module S3Storage
  class Storage < Sinatra::Base
    include AWS::S3
    AWS::S3::DEFAULT_HOST.replace "s3-ap-northeast-1.amazonaws.com"

    head '/' do
      [200, 'OK']
    end

    get '/*' do
      config = load_config
      s3_bucket_name = config['s3_bucket_name']
      s3_resource = URI.unescape(params[:splat].first).force_encoding('utf-8')
      Base.establish_connection!(
        access_key_id:     config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
      begin
        s3_object = S3Object.value(s3_resource, s3_bucket_name).response
      rescue => e
        make_response e.response
      else
        make_response s3_object
      end
    end

    put '/*' do
      config = load_config
      s3_bucket_name = config['s3_bucket_name']
      s3_resource = URI.unescape(params[:splat].first).force_encoding('utf-8')
      Base.establish_connection!(
        access_key_id:     config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
      begin
        s3_response = S3Object.store "#{s3_resource}", request.body.read, s3_bucket_name
      rescue => e
        make_response e
      else
        make_response s3_response
      end
    end

    delete '/*' do
      config = load_config
      s3_bucket_name = config['s3_bucket_name']
      s3_resource = URI.unescape(params[:splat].first).force_encoding('utf-8')
      Base.establish_connection!(
        access_key_id:     config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
      begin
        is_delete = S3Object.delete("#{s3_resource}", s3_bucket_name)
      rescue => e
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

    def load_config
      @@config ||=
        begin
          file_name = "#{File.dirname(__FILE__)}/config.yml"

          if File.exists?(file_name)
            config ||= YAML.load(IO::read(file_name))
          else
            config ||= {}
          end
          config
        end
      @@environment ||= ENV["RAILS_ENV"] ? ENV["RAILS_ENV"] : 'production'
      @@config[@@environment]
    end
  end
end


