name             'tilestache'
maintainer       'mapzen'
maintainer_email 'grant@mapzen.com'
license          'All rights reserved'
description      'Installs/Configures tilestache'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.18'

recipe 'tilestache', 'Installs tilestache'

%w{
  apache2
  apt
  git
  gunicorn
  python
  supervisor
  ulimit
  user
  yum
}.each do |dep|
  depends dep
end

%w{ redhat centos ubuntu }.each do |os|
  supports os
end
