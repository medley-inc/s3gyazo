require 'sinatra'

class S3GyazoApp < Sinatra::Base

  configure :production do
    s3 = Aws::S3::Client.new(region: ENV['S3GYAZO_REGION'])
    set :s3, s3
    set :bucket, ENV['S3GYAZO_BUCKET_NAME']
  end

  get '/' do
    'S3Gyazo'
  end

  post '/upload.cgi' do
    data = (begin
              params[:imagedata][:tempfile].read
            rescue
              params[:imagedata]
            end)
    hash = Digest::MD5.hexdigest(data).to_s
    settings.s3.put_object(acl: 'public-read', bucket: settings.bucket, body: data, key: "#{hash}.png")
    "https://#{settings.bucket}.s3.amazonaws.com/#{hash}.png"
  end

  get '/:hash.png' do
    begin
      s3obj = settings.s3.get_object(bucket: settings.bucket, key: hash)
      content_type 'image/png'
      s3obj.read
    rescue 
      content_type 'text/plain'
      halt 404, 'image not found'
    end
  end
end


