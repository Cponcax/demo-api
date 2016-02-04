namespace :geoip do
  desc 'update geoip database'
  task :update do
    url = 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz'
    system "curl #{url} | gzip -d > #{Rails.root.to_s}/lib/geoip/GeoIP.dat"
  end
end