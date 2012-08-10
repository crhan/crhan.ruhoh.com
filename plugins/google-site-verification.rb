class Ruhoh
  module Compiler
    module GoogleSiteVerification
      def self.run(target, page)
        google_verify = Ruhoh::DB.payload.dup["site"]["author"]["google_site_verification"]

        if google_verify
          FileUtils.cd(target) do
            File.open("#{google_verify}.html", 'w:UTF-8') { |p| p.puts "google-site-verification: #{google_verify}.html" }
          end
        end
      end
    end
  end
end
