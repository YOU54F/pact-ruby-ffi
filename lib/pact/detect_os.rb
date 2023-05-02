module DetectOS
  def self.windows?
    return if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['arch']).nil?

    puts 'detected windows'
    true
  end

  def self.mac_arm?
    return unless !(/darwin/ =~ RbConfig::CONFIG['arch']).nil? && !(/arm64/ =~ RbConfig::CONFIG['arch']).nil?

    puts 'detected macos arm'
    true
  end

  def self.mac?
    return unless !(/darwin/ =~ RbConfig::CONFIG['arch']).nil? && !(/x86_64/ =~ RbConfig::CONFIG['arch']).nil?

    puts 'detected macos'
    true
  end

  def self.linux_arm?
    return unless !(/linux/ =~ RbConfig::CONFIG['arch']).nil? && !(/aarch64/ =~ RbConfig::CONFIG['arch']).nil?

    puts 'detected linux aarch64'
    true
  end

  def self.linux?
    return unless !(/linux/ =~ RbConfig::CONFIG['arch']).nil? && !(/x86_64/ =~ RbConfig::CONFIG['arch']).nil?

    puts 'detected linux'
    true
  end

  def self.debug?
    return if ENV['DEBUG_TARGET'].nil?

    puts 'detected debug target' + ENV['DEBUG_TARGET']
    true
  end

  def self.get_bin_path
    if debug?
      ENV['DEBUG_TARGET'].to_s
    elsif windows?
      File.join(__dir__, '../../ffi/windows-x64/pact_ffi.dll')
    elsif mac_arm?
      File.join(__dir__, '../../ffi/macos-arm64/libpact_ffi.dylib')
    elsif mac?
      File.join(__dir__, '../../ffi/macos-x64/libpact_ffi.dylib')
    elsif linux_arm?
      File.join(__dir__, '../../ffi/linux-arm64/libpact_ffi.so')
    elsif linux?
      File.join(__dir__, '../../ffi/linux-x64/libpact_ffi.so')
    else
      raise "Detected #{RbConfig::CONFIG['arch']}-- I have no idea what to do with that."
    end
  end

  def self.get_os
    if windows?
      'win'
    elsif mac_arm?
      'macos-arm64'
    elsif mac?
      'linux-x8664'
    elsif linux_arm?
      'linux-aarch64'
    elsif linux?
      'linux-x8664'
    else
      raise "Detected #{RbConfig::CONFIG['arch']}-- I have no idea what to do with that."
    end
  end
end

puts DetectOS.get_bin_path
