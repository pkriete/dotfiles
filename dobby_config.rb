
# Standard Processes

service :mysql do |s|
  s.name  = "MySQL"
  s.file  = "/usr/local/my.cnf"

  s.start = "mysql.server start"
  s.stop  = "mysql.server stop"

  s.process = "mysqld"
end

service :memcached do |s|
  s.name  = "Memcached"
  s.start = "/usr/local/bin/memcached" # -d for daemon
  s.process  = "memcached"
end

service :php => :apache do |s|
  s.name  = "PHP"
  s.file  = "/usr/local/etc/php/5.4/php.ini"

  s.start = "php -i"
  s.process = "phpserver"

  s.start = Proc.new do |args|
    cmd = "php -i"
    cmd << "-p#{args.port}" if args.port
    cmd << "-f#{args.file}" if args.file
  end
end

service :jekyll do |s|
  s.name = "Jekyll"
  s.start = "jekyll --auto --server"
  s.process = 'jekyll'
end

service :apache do |s|
  s.name = "Apache"
  s.file = "private/etc/apache2/httpd.conf"

  s.start   = "apachectl start"
  s.stop    = "apachectl stop"
  s.restart = "apachectl restart"

  s.process = "httpd"
  s.needs_root = true
end

# Other Config Files

config :apc => :php do |c|
  c.name = "APC"
end

config :bash do |c|
  c.name = "Bash Profile"
  c.file = "~/.bash_profile"
end

config :dobby do |c|
  c.name = "Dobby Config"
  c.file = "~/.dobby_config"
end

config :git do |c|
  c.name = "Gitconfig"
  c.file = "~/.gitconfig"
end

config :gitignore do |c|
  c.name = "Gitignore"
  c.file = "~/.gitignore"
end

config :hosts do |c|
  c.name = "Hosts File"
  c.file = "/etc/hosts"
end

config :vhosts => :apache do |c|
  c.name = "Virtual Hosts"
  c.file = "/private/etc/apache2/extra/httpd-vhosts.conf"
end


# Scripted Automatic Edits
# Pipedream work in progress

class ScriptedTask

  def self.service symbol
    # grab config file name?
  end

  def self.config symbol
    # grab config file name?
  end

end



class Vhosts < ScriptedTask

  config :vhosts

  def list
    # show all files
    # merge with all in vhosts config
  end

  def create name, args
    # check if folder exists in vhosts
    # create folder in vhosts
    # create "public folder"
    # add to vhosts config
    # add to hosts file
  end

  def remove name, args
    # read file
    # check for dir
    # check for -f flag for forced removal
  end

  def rename name, new_name
    # check for dir
    # grep though file
    # rename dir
    # update file
  end

end

class Github < ScriptedTask

  def list
    # list directories
  end

  def add path, name = nil
    name ||= Pathname.basename(path)

    # check for dir
    # basepath path if name not given
    # symlink
    # check for .git -> git init
    # check for git remote -> add github?
  end

  private
    def symlink
    end

    def create_git
    end

end


# class AddVhost < ConfiggerAuto

#   def edit_vhost file, name

#   end

#   def edit_hosts file
#     # check if file contains line
#     file.append("127.0.0.1  name   # /vhosts/name")
#   end

# end


# class GithubProject < ConfiggerAuto

#   def add
#   end

#   private
#     def symlink
#     end

#     def create_git
#     end

# end

# class ToggleAPC < ConfiggerAuto

#   @options = ["on", "off"]
#   @description = "Turn APC on or off"

#   attr_reader :options, :description

#   def current?
#     "On"
#   end

# end

# class PHPVersion < ConfiggerAuto

#   @options = ["PHP 5.3", "PHP 5.4"]
#   @description = "Change PHP Version"

#   attr_reader :options, :description

#   def current?
#     "PHP 5.3" # should return current version
#   end

# end

# automate :php, PHPVersion.new