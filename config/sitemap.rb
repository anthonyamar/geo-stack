require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://example.com'
SitemapGenerator::Sitemap.create do
  add '/home', priority: 0.9

  # YourModel.find_each do |model|
  #   add "/model/#{model.slug}", priority: 0.7
  # end
end

# Not needed if you use the rake tasks
# SitemapGenerator::Sitemap.ping_search_engines
