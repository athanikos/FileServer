require 'sinatra'
require 'fileutils'

set :bind, '0.0.0.0'
set :port, 4567

MEDIA_ROOT = File.expand_path('./media')

post '/upload/:device_id' do
  device = params[:device_id]
  FileUtils.mkdir_p("#{MEDIA_ROOT}/#{device}")

  if params[:file]
    filename = params[:file][:filename]
    tempfile = params[:file][:tempfile]
    path = File.join(MEDIA_ROOT, device, filename)
    File.open(path, 'wb') { |f| f.write(tempfile.read) }
    status 200
    "Uploaded #{filename}"
  else
    status 400
    "No file uploaded"
  end
end

get '/media/:device_id/:filename' do
  path = File.join(MEDIA_ROOT, params[:device_id], params[:filename])
  File.exist?(path) ? status(200) : status(404)
end
