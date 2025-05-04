require 'sinatra'
require 'fileutils'

set :bind, '0.0.0.0'
set :port, 4567

MEDIA_ROOT = File.expand_path('./media')

post '/upload/:device_id' do
  device = params[:device_id]
  halt 400, "Missing device ID" unless device

  unless params[:file] &&
         params[:file][:filename] &&
         params[:file][:tempfile]
    halt 400, "Missing or malformed file upload"
  end

  begin
    FileUtils.mkdir_p("#{MEDIA_ROOT}/#{device}")
    filename = params[:file][:filename]
    tempfile = params[:file][:tempfile]
    path = File.join(MEDIA_ROOT, device, filename)

    File.open(path, 'wb') { |f| f.write(tempfile.read) }
    status 201
    "Uploaded #{filename} from #{device}"
  rescue => e
    puts "[ERROR] Upload failed: #{e.message}"
    halt 500, "Internal Server Error"
  end
end


get '/view/phone01' do
  "Hello World"
end

get '/media/:device_id/:filename' do
  path = File.join(MEDIA_ROOT, params[:device_id], params[:filename])
  File.exist?(path) ? status(200) : status(404)
end
