require 'nokogiri'
class Ruhoh
  module Compiler
    module Sitemap
      def self.run(target, page)
        production_url = Ruhoh::DB.site['config']['production_url']

        config = Ruhoh::DB.site['plugins']['sitemap_generator'] rescue []
        sitemap_file_name = config['file_name'] rescue "sitemap.xml"
        exclude_page = config['exclude'] rescue []

        sitemap = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") {
            Ruhoh::DB.posts['chronological'].each do |post_id|
              post = Ruhoh::DB.posts['dictionary'][post_id]
              page.change(post_id)
              xml.url {
                xml.loc_ "#{production_url}#{post['url']}"
                xml.lastmod_ (post['lastmod'] ? post['lastmod'] : post['date'])
                if !!post['priority']
                  xml.priority_ post['priority']
                end
              }
            end #posts

            Ruhoh::DB.pages.each do |name, meta|
              next if exclude_page.include? meta['id']
              xml.url {
                xml.loc_ "#{production_url}#{meta['url']}"
              }
            end #pages
          }
        end
        File.open(File.join(target, sitemap_file_name), 'w') { |p| p.puts sitemap.to_xml }
        Ruhoh::Friend.say { green "processed: #{sitemap_file_name}" }
      end
    end #Sitemap
  end #Compiler
end #Ruhoh
