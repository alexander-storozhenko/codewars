class DurationFormatter
    def initialize
      @time = { minute: 60, hour: 60 * 60, day: 60 * 60 * 24, year: 60 * 60 * 24 * 365 }
      @result = []  
    end

    def format_duration(input)
        return 'now' if input.zero?

        build_string(input)
    
        return @result.join(', ')if @result.size == 1

        *head, last = @result
        "#{head.join(', ')} and #{last}"
    end

    private
  
    def format(seconds, string = :second)
      return if seconds.zero?
      return @result << (seconds == 1 ? "#{seconds} #{string}" : "#{seconds} #{string}s") if string == :second

      time = @time[string]
      formatted_value = seconds / time

      return if formatted_value.zero?
     
      @result << (seconds < 2 * time ? "#{formatted_value} #{string}" : "#{formatted_value} #{string}s")
    end
  
    def build_string(input)
      minute, hour, day, year = @time.values

      return format(input) if input < minute
      return format(input, :minute), format(input % minute) if input < hour
      return format(input, :hour), format(input % hour, :minute), format(input % minute) if input < day
      return format(input, :day), format(input % day, :hour), format(input % hour, :minute), format(input % minute) if input < year
      return format(input, :year), format(input % year, :day), format(input % day, :hour), format(input % hour, :minute), format(input % minute)
    end
  end
  
  def format_duration(input)
    DurationFormatter.new.format_duration(input)
  end