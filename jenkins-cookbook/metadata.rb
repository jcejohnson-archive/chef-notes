name             'tragus_jenkins'
license          'All rights reserved'
description      'Installs/Configures tragus_jenkins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends "jenkins", "~> 2.3.0"
depends "runit", "~> 1.6.0"