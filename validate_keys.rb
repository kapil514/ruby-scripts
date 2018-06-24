require 'yaml'
require 'curb'

expired_keys     = Hash.new
curl             = Curl::Easy.new
curl.proxy_url   = ARGV[0]
api_keys         = YAML::load(File.read('api_keys.yml'))
url_formats      = YAML::load(File.read('url_formats.yml'))
api_keys.each do |feed,keys|
  url_prefix = if feed.include? "googleplus"
    url_formats["googleplus"]
  else
    url_formats["youtube"]
  end
  keys.each do |key|
    connector = key.keys[0]
    api_key = key.values[0]
    puts "Validating api key of connector #{connector} of #{feed}"
    url = url_prefix+api_key
    curl.url = url
    curl.http_get
    response = eval(curl.body_str)
    if response.has_key? :error and response[:error][:errors][0][:reason] == "keyExpired"
      expired_keys["#{feed}:#{connector}"]=api_key
    end   
  end
end
puts "#############Expired Keys###############"
puts expired_keys.inspect
