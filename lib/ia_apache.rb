module Ia::Apache

  # Genera el archivo de configuración para Apache para un proyecto concreto
  def apache_gen_config_file(name,path)
    config = %{
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName #{name}-dev.emergya-gpi.es
  DocumentRoot /var/www/projects/#{name}/trunk
  <Directory /var/www/projects/#{name}/trunk>
    Options FollowSymLinks
    AllowOverride All
    Order deny,allow
    Allow from all
  </Directory>

  ErrorLog /var/log/apache2/projects/#{name}-dev-error.log
  LogLevel warn
  CustomLog /var/log/apache2/projects/#{name}-dev-access.log combined
  ServerSignature On
</VirtualHost>

<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName #{name}-test.emergya-gpi.es
  DocumentRoot /var/www/projects/#{name}/branches/prod
  <Directory /var/www/projects/#{name}/branches/prod>
    Options FollowSymLinks
    AllowOverride All
    Order deny,allow
    Allow from all
  </Directory>

  ErrorLog /var/log/apache2/projects/#{name}-test-error.log
  LogLevel warn
  CustomLog /var/log/apache2/projects/#{name}-test-access.log combined
  ServerSignature On
</VirtualHost>
    }

    path ||= "/etc/apache2/sites-available"
    file = File.new("#{path}/#{name}", "w")
    file.write(config)
    file.close
    
  end

end
