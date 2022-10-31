module DetectOS
  def self.windows_arm?
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['arch']) != nil and (/arm64/ =~ RbConfig::CONFIG['arch']) != nil
      puts 'detected windows arm'
      true
    end
  end

  def self.windows?
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['arch']) != nil and (/arm64/ =~ RbConfig::CONFIG['arch']).nil?
      puts 'detected windows'
      true
    end
  end

  def self.mac_arm?
    if (/darwin/ =~ RbConfig::CONFIG['arch']) != nil and (/arm64/ =~ RbConfig::CONFIG['arch']) != nil
      puts 'detected macos arm'
      true
    end
  end

  def self.mac?
    if (/darwin/ =~ RbConfig::CONFIG['arch']) != nil and (/arm64/ =~ RbConfig::CONFIG['arch']).nil?
      puts 'detected macos'
      true
    end
  end

  def self.linux_arm?
    if (/linux/ =~ RbConfig::CONFIG['arch']) != nil and (/arm64/ =~ RbConfig::CONFIG['arch']) != nil
      puts 'detected linux arm'
      true
    end
  end

  def self.linux?
    if (/linux/ =~ RbConfig::CONFIG['arch']) != nil and (/arm64/ =~ RbConfig::CONFIG['arch']).nil?
      puts 'detected linux'
      true
    end
  end
end
