module OS
  def OS.windows_arm?
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG["arch"]) != nil and (/arm64/ =~ RbConfig::CONFIG["arch"]) != nil
      puts "detected windows arm"
      return true
    end
  end
  
  def OS.windows?
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG["arch"]) != nil and (/arm64/ =~ RbConfig::CONFIG["arch"]) == nil
      puts "detected windows"
      return true
    end
  end
  def OS.mac_arm?
    if (/darwin/ =~ RbConfig::CONFIG["arch"]) != nil and (/arm64/ =~ RbConfig::CONFIG["arch"]) != nil
      puts "detected macos arm"
      return true
    end
  end
  
  def OS.mac?
    if (/darwin/ =~ RbConfig::CONFIG["arch"]) != nil and (/arm64/ =~ RbConfig::CONFIG["arch"]) == nil
      puts "detected macos"
      return true
    end
  end
  def OS.linux_arm?
    if (/linux/ =~ RbConfig::CONFIG["arch"]) != nil and (/arm64/ =~ RbConfig::CONFIG["arch"]) != nil
      puts "detected linux arm"
      return true
    end
  end
  
  def OS.linux?
    if (/linux/ =~ RbConfig::CONFIG["arch"]) != nil and (/arm64/ =~ RbConfig::CONFIG["arch"]) == nil
      puts "detected linux"
      return true
    end
  end
end
