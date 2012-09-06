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
