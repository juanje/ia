module Ia::Drupal

  # Gestion de archivos para drupal
  module Files
    # Busca archivos potencialmente inseguros y los borra si existen
    # pretend (Boolean): si es verdadero solo imprime las modificaciones
    def drupal_rm_files(pretend)
      txt_files = %w(CHANGELOG.txt
                     CONTRIBUTORS.es.txt
                     COPYRIGHT.txt
                     INSTALL.mysql.txt
                     INSTALL.pgsql.txt
                     INSTALL.txt
                     LICENSE.es.txt
                     LICENSE.txt
                     MAINTAINERS.txt
                     README.es.txt
                     STATUS.es.txt
                     UPGRADE.txt)
      php_files = %w(install.php phpinfo.php)
      files = txt_files + php_files
      files.each do |f|
        if pretend
          pinfo("rm #{f}")  if FileTest.exist?(f)
        else
          system("rm #{f}") if FileTest.exist?(f)
        end
      end
    end

    def drupal_secure_files(pretend)
      files = %w(upgrade.php cron.php)
    end
  end

end

