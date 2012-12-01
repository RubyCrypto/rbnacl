if defined? JRUBY_VERSION
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new('rbnacl_ext') do |ext|
    ext.ext_dir = 'ext/rbnacl'
  end
else
  require 'rake/extensiontask'
  Rake::ExtensionTask.new('rbnacl_ext') do |ext|
    ext.ext_dir = 'ext/rbnacl'
  end
end
