require 'date'
require 'yaml'

module NepaliDateConverter
  class Calendar
    NEPALI_MONTHS            = %w(Baishakh Jestha Ashad Shrawan Bhadra Ashwin Kartik Mangshir Poush Magh Falgun Chaitra)
    NEPALI_MONTHS_DEVANAGARI = %w(बैशाख जेठ असार श्रावण भदौ आश्विन कार्तिक मंसिर पुष माघ फाल्गुन चैत्र)
    WEEK_DAYS                = %w(आइतबार सोमबार मंगलबार बुधवार बिहीबार शुक्रबार शनिबार)

    # Default BS_CALENDAR data (fallback)
    BS_CALENDAR_DEFAULT = BS_CALENDAR = [
        [2000, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2001, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2002, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2003, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2004, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2005, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2006, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2007, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2008, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
        [2009, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2010, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2011, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2012, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
        [2013, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2014, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2015, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2016, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
        [2017, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2018, 31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2019, 31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2020, 31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
        [2021, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2022, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
        [2023, 31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2024, 31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
        [2025, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2026, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2027, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2028, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2029, 31, 31, 32, 31, 32, 30, 30, 29, 30, 29, 30, 30],
        [2030, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2031, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2032, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2033, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2034, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2035, 30, 32, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
        [2036, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2037, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2038, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2039, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
        [2040, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2041, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2042, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2043, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
        [2044, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2045, 31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2046, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2047, 31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
        [2048, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2049, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
        [2050, 31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2051, 31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
        [2052, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2053, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
        [2054, 31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2055, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2056, 31, 31, 32, 31, 32, 30, 30, 29, 30, 29, 30, 30],
        [2057, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2058, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2059, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2060, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2061, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2062, 30, 32, 31, 32, 31, 31, 29, 30, 29, 30, 29, 31],
        [2063, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2064, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2065, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2066, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
        [2067, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2068, 31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2069, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2070, 31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
        [2071, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2072, 31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
        [2073, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
        [2074, 31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
        [2075, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2076, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
        [2077, 31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
        [2078, 31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
        [2079, 31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
        [2080, 31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
        [2081, 31, 31, 32, 32, 31, 30, 30, 30, 29, 30, 30, 30],
        [2082, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
        [2083, 31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
        [2084, 31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
        [2085, 31, 32, 31, 32, 30, 31, 30, 30, 29, 30, 30, 30],
        [2086, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
        [2087, 31, 31, 32, 31, 31, 31, 30, 30, 29, 30, 30, 30],
        [2088, 30, 31, 32, 32, 30, 31, 30, 30, 29, 30, 30, 30],
        [2089, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
        [2090, 30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30]
  ]

    # Load BS_CALENDAR dynamically from config or fallback to default
    def self.load_bs_calendar
      # Check if running in a Rails application
      if defined?(Rails)
        config_path = Rails.root.join('config', 'bs_calendar.yml')
        if File.exist?(config_path)
          YAML.load_file(config_path)
        else
          Rails.logger.warn("BS Calendar config file not found at #{config_path}. Using default BS_CALENDAR.")
          BS_CALENDAR_DEFAULT
        end
      else
        BS_CALENDAR_DEFAULT
      end
    end

    # Define BS_CALENDAR as a constant, loaded dynamically
    BS_CALENDAR = load_bs_calendar

    class << self
      # Return english day of week
      #
      # Example:
      #
      #   get_day_of_week(1) # => Sunday
      #   get_day_of_week(2) # => Monday
      #
      def get_day_of_week(idx, devanagari: false)
        devanagari ? WEEK_DAYS[idx - 1] : Date::DAYNAMES[idx - 1]
      end
      
      # Return english month name
      #
      # Example:
      #
      #    get_english_month(1) # => January
      #    get_english_month(12) # => December
      #
      def get_english_month(idx)
        Date::MONTHNAMES[idx]
      end
      
      # Return nepali month name
      #
      # Example:
      #
      #    get_nepali_month(1)    # => Baishakh
      #    get_nepali_month(2)    # => Jestha
      #
      def get_nepali_month(idx, devanagari: false)
        devanagari ? NEPALI_MONTHS_DEVANAGARI[idx-1] : NEPALI_MONTHS[idx - 1]
      end
      
      # Check if date range is in english date
      #
      #  is_in_range_eng(1944, 12, 31)  # => true
      #
      def valid_english_date?(year, month, day)
        raise 'Supported only between 1944-2033' unless (1944 .. 2033).include?(year)
        raise 'Invalid month range' unless (1 .. 12).include?(month)
        raise 'Invalid day range' unless (1 .. 31).include?(day)
        true
      end
      
      # check if date range is in nepali date
      #
      def valid_nepali_date?(year, month, day)
        raise 'Supported only between 2000-2089' unless (2000 .. 2089).include?(year)
        raise 'Invalid month range' unless (1 .. 12).include?(month)
        raise 'Invalid day range' unless (1 .. 32).include?(day)
        true
      end
      
      # Check if given year is leap year
      #
      def is_leap_year?(year)
        # Date.leap?(year)
        if year % 100 == 0
          if year % 400 == 0
            return true
          else
            return false
          end
        else
          if year % 4 == 0
            return true
          else
            return false
          end
        end
      end
    end
  end
end
