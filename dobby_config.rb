
# Standard Processes

service :apache do |s|
  s.name = 'Apache'
  s.file = '/private/etc/apache2/httpd.conf'

  s.start   = 'apachectl start'
  s.stop    = 'apachectl stop'
  s.restart = 'apachectl restart'

  s.process = 'httpd'
  s.needs_root = true
end

service :jekyll do |s|
  s.name = 'Jekyll'
  s.start = 'jekyll --auto --server'
  s.process = 'jekyll'
end

service :memcached do |s|
  s.name  = 'Memcached'
  s.start = '/usr/local/bin/memcached' # -d for daemon
  s.process  = 'memcached'
end

service :mysql do |s|
  s.name  = 'MySQL'
  s.file  = '/usr/local/my.cnf'

  s.start = 'mysql.server start'
  s.stop  = 'mysql.server stop'

  s.process = 'mysqld'
end

service :php => :apache do |s|
  s.name  = 'PHP'
  s.file  = '/usr/local/etc/php/5.4/php.ini'

  s.process = 'php'
  s.start = Proc.new do |args|

    flags = args.parse({
      '-p' => { :default => 8000, :alias => '--port' },
      '-t' => { :alias => '--root' }
    })

    cmd = "php -S localhost:#{flags['-p']}"
    cmd << " -t #{flags['-t']}" if flags['-t']
    cmd
  end
end

service :postgres do |s|
  s.name = 'Postgres'
  # s.file = ''

  s.start = 'pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
  s.stop = 'pg_ctl -D /usr/local/var/postgres stop -s -m fast'

  s.process = 'postgres'
end

service :redis do |s|
  s.name = 'Redis'
  s.file = '/usr/local/etc/redis.conf'

  s.start = 'redis-server /usr/local/etc/redis.conf'
  s.process = 'redis-server'
end

# Other Config Files

config :bash do |c|
  c.name = 'Bash Profile'
  c.file = '~/.bash_profile'
end

config :dobby do |c|
  c.name = 'Dobby Config'
  c.file = '~/.dobby_config'
end

config :git do |c|
  c.name = 'Gitconfig'
  c.file = '~/.gitconfig'
end

config :gitignore do |c|
  c.name = 'Gitignore'
  c.file = '~/.gitignore'
end

config :hosts do |c|
  c.name = 'Hosts File'
  c.file = '/etc/hosts'
end

config :php_apc => :php do |c|
  c.name = 'APC (PHP)'
  c.file = '/usr/local/etc/php/5.4/conf.d/ext-apc.ini'
end

config :php_memcached => :php do |c|
  c.name = 'Memcached (PHP)'
  c.file = '/usr/local/etc/php/5.4/conf.d/ext-memcached.ini'
end

config :php_mongo => :php do |c|
  c.name = 'Mongo (PHP)'
  c.file = '/usr/local/etc/php/5.4/conf.d/ext-mongo.ini'
end

config :php_redis => :php do |c|
  c.name = 'Redis (PHP)'
  c.file = '/usr/local/etc/php/5.4/conf.d/ext-redis.ini'
end

config :php_xdebug => :php do |c|
  c.name = 'Xdebug (PHP)'
  c.file = '/usr/local/etc/php/5.4/conf.d/ext-xdebug.ini'
end

# config :puppet do |c|
#   c.name = 'Puppet'
#   c.file = '/etc/puppet'
#   c.file = '~/.puppet'
# end

config :vhosts => :apache do |c|
  c.name = 'Virtual Hosts'
  c.file = '/private/etc/apache2/extra/httpd-vhosts.conf'
end