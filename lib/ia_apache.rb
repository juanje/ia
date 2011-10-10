module Ia::Apache

  # Genera el archivo de configuración para Apache para un proyecto concreto
  def apache_gen_config_file(name,path)

    config = ""
    if queca?
      domain = "queca.lan"

      config << %{<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName #{name}.#{domain}
    ServerAlias *.#{name}.#{domain}
    DocumentRoot /var/www/projects/#{name}/trunk
    
    <Directory /var/www/projects/#{name}/trunk>
      Options FollowSymLinks
      AllowOverride All
      Order deny,allow
      Allow from all
    </Directory>

    ErrorLog /var/log/apache2/projects/#{name}-error.log
    LogLevel warn
    CustomLog /var/log/apache2/projects/#{name}-access.log combined
    ServerSignature On
  </VirtualHost>
  }
    else
      domain = "emergya-gpi.es"

      %w(dev test).each do |i|
        config << %{<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName #{name}-#{i}.#{domain}
    ServerAlias *.#{name}-#{i}.#{domain}
    DocumentRoot /var/www/projects/#{name}/trunk
    
    <Directory /var/www/projects/#{name}/trunk>
      Options FollowSymLinks
      AllowOverride All
      Order deny,allow
      Allow from all
    </Directory>

    ErrorLog /var/log/apache2/projects/#{name}-#{i}-error.log
    LogLevel warn
    CustomLog /var/log/apache2/projects/#{name}-#{i}-access.log combined
    ServerSignature On
  </VirtualHost>
  }
      end
    end

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
