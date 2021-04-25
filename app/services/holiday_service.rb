class HolidayService
  def self.get_holidays
    resp = conn.get('/Api/v2/NextPublicHolidays/US')
    json = JSON.parse(resp.body, symbolize_names: true)[0..2]

    upcoming_holidays = {}
    json.each do |holiday|
      upcoming_holidays[holiday[:localName]] = holiday[:date]
    end
    upcoming_holidays
  end
  
  def self.conn
    Faraday.new(url: 'https://date.nager.at')
  end
end
