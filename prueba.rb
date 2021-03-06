require 'uri'
require 'net/http'
require 'openssl'
require 'json'


#A este método le agregamos una url de api y una api_key, las concatena y nos da la respuesta de una request.
def request(url, key)
    url_with_key = url + key

    url_api = URI(url_with_key)

    http = Net::HTTP.new(url_api.host, url_api.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url_api)
    request["cache-control"] = 'no-cache'
    request["postman-token"] = 'ccff926c-07c3-4696-0da0-7a689690bd5e'

    response = http.request(request)
    response_hash = JSON.parse(response.read_body)
end

=begin
Al método debemos darle como argumento 1 la respuesta de la url de la nasa a la que queremos hicimos la request y nos armará un index.html
=end

def build_web_page(hash)
 
    response_array = hash['photos']

    middle_html = []
    (response_array.length).times { |x| response_array[x].each { |k, v| middle_html.push(v) if k == 'img_src' } }

    final_html = ["<html>","<head>", "</head>", "<body>", "<ul>"]
    bottom_html = ["</ul>", "</body>", "</html>"]
    
    (middle_html.length).times { |y| final_html.push("\t<li><img src=\"#{middle_html[y]}\" width='700' height='500'></li>")}
    (bottom_html.length).times { |z| final_html.push(bottom_html[z]) }

    File.new("index.html", "w")
    File.write('index.html', final_html.join("\n"))
end

#al siguiente método al darle como argumento la url de la api de la nasa, nos devuelve un hash con cada cámara y cantidad de fotos que fueron sacadas.

def photo_count(hash)
    response_array = hash['photos']
    filter_array = []
    (response_array.length).times do |x|
        response_array[x].each { |k, v| filter_array.push(v) if k == "camera" }
    end

    camera_array = []
    (filter_array.length).times do |x|
        filter_array[x].each { |k, v| camera_array.push(v) if k == "full_name" }
    end

    counts = Hash.new(0)
    photo_counts = camera_array.each { |name| counts[name] += 1 }

    print counts
end


response_hash = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=", "icwWBO3w7LZOFTFwt4HheCVdRpPzlqacMxZDYyOL&page=1")

build_web_page(response_hash)


photo_count(response_hash)



