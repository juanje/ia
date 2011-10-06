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

end
