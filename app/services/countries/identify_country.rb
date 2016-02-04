module Countries
  class IdentifyCountry < BaseService
    NOT_ALLOWED_IPS = %w[127.0.0.1]

    attr_reader :geoip, :remote_ip
      
    def initialize(current_user, remote_ip)
      super(current_user)

      @geoip ||= GeoIP.new('lib/geoip/GeoIP.dat')
      @remote_ip = remote_ip
    end

    def call
      begin
        current_user.update_attribute(:country_id, Country.find_or_create_by(args).id)
      rescue Exception => e
        puts "Error: #{e.message}"
      end
    end

    private

      def location
        unless NOT_ALLOWED_IPS.include? remote_ip
          return geoip.country(remote_ip)
        end
      end

      def args
        { 
          code: location.country_code, 
          alpha2: location.country_code2, 
          alpha3: location.country_code3, 
          name: location.country_name
        }
      end

  end
end
