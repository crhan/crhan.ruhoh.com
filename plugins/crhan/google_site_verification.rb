# Google Site Verification Generator is Ruhoh plugin that generate a verify
# page for Google Webmaster to check
#
# How to Use:
#   1.) Copy this file to your blog's plugins folder within your Ruhoh project
#   2.) Custom settings in the ruhoh's site.yml (See Notes)
#
# Notes:
#   1.) Full config of this plugin (required)
#
#        #plugins:
#        #  google_site_verification: googlef056ebc4b89ca27a #<- this is my code
#
# Author: Ruohan Chen
# Site: https://github.com/crhan/ruhoh_plugins
# Distributed Under A Creative Commons License
#   - http://creativecommons.org/licenses/by-sa/3.0/

class Ruhoh
  module Compiler
    module GoogleSiteVerification
      def self.run(target, page)
        google_verify = Ruhoh::DB.site['plugins']["google_site_verification"] rescue nil

        if google_verify
          FileUtils.cd(target) do
            File.open("#{google_verify}.html", 'w:UTF-8') do |p|
              p.puts "google-site-verification: #{google_verify}.html"
            end
          end
          Ruhoh::Friend.say { green "processed: #{google_verify}.html" }
        else
          Ruhoh::Friend.say { red "warning: please add
```
plugins:
  google_site_verification: verify_code (with out '.html')
```
in your `site.yml` file ;-)" }
        end

      end
    end #GoogleSiteVerification
  end #Compiler
end #Ruhoh
