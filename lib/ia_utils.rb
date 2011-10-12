require 'simple_progressbar'

module Ia::Utils
  # Imprime un mensaje del tipo informativo
  # * msg(String): mensaje
  # * level(Integer): nivel de identación del mensaje
  def pinfo(msg,level = 1)
    puts " " * level + "* ".color(:green) + msg
  end

  # Imprime un mensaje del tipo aviso
  # * msg: mensaje
  # * level: nivel de identación del mensaje
  def pwarn(msg,level = 1)
    puts " " * level + "* ".color(:yellow) + msg
  end

  # Imprime un mensaje del tipo error
  # * msg: mensaje
  # * level: nivel de identación del mensaje
  def perr(msg,level = 1)
    puts " " * level + "* ".color(:red) + msg
  end

  def pbar(msg,counter=3)
    SimpleProgressbar.new.show(msg) do
      (0..counter).each {|i|
        progress i*10
        sleep(1)
      }
    end
  end

  # Parseador de ficheros YAML
  def yaml_read(file)
    if FileTest.exists?(file)
      require 'yaml'
      YAML.load_file(file)
    else
      perr("El archivo #{file} no existe.")
    end
  end
  
  # ¿Estamos ejecutandonos en un QuecaSDK?
  def queca?
    if FileTest.exists?("/home/user/.QuecaSDK")
      return true
    else
      return false
    end
  end


  def command?(options)
    raise "Necesitas especificar un comando".color(:red) unless options.size > 0
  end
  def name?(global_options)
    raise "** Necesitas especificar un nombre de proyecto (-n)".color(:red) unless global_options[:name]
  end
  def remote?(global_options)
    raise "** Necesitas especificar un servidor remoto QuecaSDK (-r)".color(:red) unless global_options[:remote]
  end
  def git?(global_options)
    raise "** No estas en un repo GIT".color(:red) unless FileTes.exists?(".git")
  end
  def iacfg?(global_options)
    raise "** Necesitas definir ~/.ia_config para usar este comando".color(:red) unless FileTes.exists?("~/.ia_config")
  end

end
