def build_web_page(url, photos = 5)
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'json'

    url = URI(url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["cache-control"] = 'no-cache'
    request["postman-token"] = 'ccff926c-07c3-4696-0da0-7a689690bd5e'

    response = http.request(request)
    response_array_raw = JSON.parse(response.read_body)
    response_array = response_array_raw['photos']

    filtered_url = []
    (response_array.length).times { |x| response_array[x].each { |k, v| filtered_url.push(v) if k == 'img_src' } }

    final_html = ["<html>","<head>", "</head>", "<body>", "<ul>"]
    bottom_html = ["</ul>", "</body>", "</html>"]
    middle_html = filtered_url.sample(photos)
    (middle_html.length).times { |y| final_html.push("<li><img src=\"#{middle_html[y]}\"></li>")}
    (bottom_html.length).times { |z| final_html.push(bottom_html[z]) }

    File.new("index.html", "w")
    File.write('index.html', final_html.join("\n"))
end

=begin
Al método debemos darle como argumento 1 la url de la nasa a la que queremos hacer la request, y un número que será la cantidad de fotos que se mostrará.
Ingresados esos argumentos, el programa genera un archivo index.html con la cantidad de fotos aleatorias listadas en elementos <li>.
En esta URL hay 856 fotos.
=end



build_web_page("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=icwWBO3w7LZOFTFwt4HheCVdRpPzlqacMxZDYyOL", 3)


