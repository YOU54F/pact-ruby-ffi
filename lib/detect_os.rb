module DetectOS
  def self.windows?
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['arch']) != nil
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
    if (/darwin/ =~ RbConfig::CONFIG['arch']) != nil
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
    if (/linux/ =~ RbConfig::CONFIG['arch']) != nil
      puts 'detected linux'
      true
    end
  end

  def self.debug?
    if ENV['DEBUG_TARGET'] != nil
      puts 'detected debug target' + ENV['DEBUG_TARGET']
      true
    end
  end

  def self.get_bin_path
    if debug?
      ENV['DEBUG_TARGET'].to_s
    elsif windows?
      'pact/ffi/windows/pact_ffi.dll.lib'
    elsif mac_arm?
      './pact/ffi/osxaarch64/libpact_ffi.dylib'
    elsif mac?
      './pact/ffi/osxx8664/libpact_ffi.dylib'
    elsif linux_arm?
      './pact/ffi/linuxaarch64/libpact_ffi.so'
    elsif linux?
      './pact/ffi/linuxx8664/libpact_ffi.so'
    else
      raise "Detected #{RbConfig::CONFIG['arch']}-- I have no idea what to do with that."
    end
  end
end

puts DetectOS.get_bin_path
