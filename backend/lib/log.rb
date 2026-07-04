module Log
  def self.success(message)
    puts "\e[32m[SUCCESS]\e[0m #{message}"
  end

  def self.error(message)
    puts "\e[31m[ERROR]\e[0m #{message}"
  end

  def self.warning(message)
    puts "\e[33m[WARNING]\e[0m #{message}"
  end
end
