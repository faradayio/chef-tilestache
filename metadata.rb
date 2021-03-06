name             'tilestache'
maintainer       'mapzen'
maintainer_email 'grant@mapzen.com'
license          'GPL v3'
description      'Installs/Configures tilestache'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.14.0'

recipe 'tilestache', 'Installs tilestache'

%w(
  apache2
  apt
  git
  gunicorn
  python
  runit
  supervisor
  ulimit
  user
  yum
).each do |dep|
  depends dep
end

%w(ubuntu).each do |os|
  supports os
end
