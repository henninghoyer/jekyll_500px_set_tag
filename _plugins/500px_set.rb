# 500px Set Tag.
#
# Generates an image gallery from a 500px set. Based on the works
# macjasp & tsmango. 
#
# Usage:
#
#   {% fpx_set 500px_username %}
#
# Example:
#
#   {% fpx_set henninghoyer %}
#
# Default Configuration (override in _config.yml):
#
# fpx_set:
#  gallery_tag:    "p"
#  gallery_class:  "fpxgallery"
#  a_target:       "_blank"
#  image_rel:      ""
#  feature:        "user"
#  consumer_key:   ""  
#
# By default, thumbnails are linked to their corresponding 500px page.
#
# You must provide an API Key in order to query 500px. It must be configured in _config.yml.
#
# Author: Henning Hoyer
# Site: http://henninghoyer.com
# Plugin Source: http://github.com/henninghoyer/jekyll_500px_set_tag
# Site Source: http://github.com/henninghoyer/henninghoyer.com
# Plugin License: MIT

require 'net/https'
require 'uri'
require 'json'

module Jekyll
  class FpxSetTag < Liquid::Tag
    def initialize(tag_name, config, token)
      super

      @set  = config.strip

      @config = Jekyll.configuration({})['fpx_set'] || {}

      @config['gallery_tag']   ||= 'p'
      @config['gallery_class'] ||= 'fpxgallery'
      @config['a_target']      ||= '_blank'
      @config['image_rel']     ||= ''
      @config['per_page']      ||= ''
      @config['feature']       ||= 'user'
      @config['consumer_key']  ||= ''
    end

    def render(context)
      html = "<#{@config['gallery_tag']} class=\"#{@config['gallery_class']}\">"

      photos.each do |photo|
        html << "<a href=\"#{photo.full_url}\" target =\"#{@config['a_target']}\">"
        html << "  <img src=\"#{photo.thumb_url}\" rel=\"#{@config['image_rel']}\" alt=\"#{photo.title}\"/>"
        html << "</a>"
      end

      html << "</#{@config['gallery_tag']}>"

      return html
    end

    def photos
      @photos = Array.new

      JSON.parse(json)['photos'].each do |item|
        @photos << FpxPhoto.new(item['name'], item['id'], item['images'][0]['url'])
      end

      @photos.sort
    end

    def json
      uri = URI.parse("https://api.500px.com/v1/photos?feature=#{@config['feature']}&username=#{@set}&consumer_key=#{@config['consumer_key']}&image_size[]=1&image_size[]=4")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      return http.request(Net::HTTP::Get.new(uri.request_uri)).body
    end
  end

  class FpxPhoto

    def initialize(title, id, thumb_url)
      @title          = title
      @thumb_url      = thumb_url
      @full_url       = "http://www.500px.com/photo/#{id}"
    end

    def title
      return @title
    end

    def thumb_url
      return @thumb_url
    end
      
    def full_url
      return @full_url
    end

    def <=>(photo)
      @title <=> photo.title
    end
  end
end

Liquid::Template.register_tag('fpx_set', Jekyll::FpxSetTag)
