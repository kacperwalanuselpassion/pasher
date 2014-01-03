class TimeUtils
  class << self
    def now
      Time.now.utc
    end

    def to_timestamp(time)
      if time.is_a?(Time)
        time.getutc
      elsif time.is_a?(String)
        time = parse(time)
        time.getutc if time
      end
    end

    def parse(string)
      Time.parse(string).utc rescue nil
    end
  end
end