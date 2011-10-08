module Ia::Apache

  # Genera el archivo de configuración para Apache para un proyecto concreto
  def apache_gen_config_file(name,path)
    config = %{
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName #{name}-dev.emergya-gpi.es
  ServerAlias *.#{name}-dev.emergya-gpi.es
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
  ServerAlias *.#{name}-test.emergya-gpi.es
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

    raise "El archivo ya existe, borralo primero" if FileTest.exists?("#{path}/#{name}")

    file = File.new("#{path}/#{name}", "w")
    file.write(config)
    file.close

    pinfo("Recuerda activar el virtualhost y recargar apache: ia apache -g #{$name} -e ")
  end

  # Activa la configuracion y recarga apache
  def apache_enable_site(name)
    pinfo("Activando configuracion..")
    system("a2ensite #{name}")

    pwarn('*** Apache va a recargarse (3s para cancelar ctrl+c) *** '.color(:yellow))
    sleep 3

    system("service apache2 reload")
  end

 end
