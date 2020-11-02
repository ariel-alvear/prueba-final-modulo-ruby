=begin
Generate API Key
Your API key for ariel.alvear.l@gmail.com is:

icwWBO3w7LZOFTFwt4HheCVdRpPzlqacMxZDYyOL
You can start using this key to make web service requests. Simply pass your key in the URL when making a web request. Here's an example:

https://api.nasa.gov/planetary/apod?api_key=icwWBO3w7LZOFTFwt4HheCVdRpPzlqacMxZDYyOL
For additional support, please contact us. When contacting us, please tell us what API you're accessing and provide the following account details so we can quickly find you:

Account Email: ariel.alvear.l@gmail.com
Account ID: 8c6f95e3-9bb2-4875-90f1-8db8d59fd0b7 
"<img src=\"#{photo}\">\n"
=end


def build_web_page(url, photos = 5)
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
    (response_array.length).times do |x|
        response_array[x].each do |k, v|
            if k == 'img_src'
                filtered_url.push(v)
            end
        end
    end

    top_html = ["<html>","<head>", "</head>", "<body>", "<ul>"]
    bottom_html = ["</ul>", "</body>", "</html>"]
    middle_html = filtered_url.sample(photos)
    final_html = []
    (top_html.length).times do |x|
        final_html.push(top_html[x])
    end
    (middle_html.length).times do |y|
        final_html.push("<li><img src=\"#{middle_html[y]}\"></li>")
    end
    (bottom_html.length).times do |z|
        final_html.push(bottom_html[z])
    end

    File.new("index.html", "w")
    File.write('index.html', final_html.join("\n"))
end

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

build_web_page("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=icwWBO3w7LZOFTFwt4HheCVdRpPzlqacMxZDYyOL")


