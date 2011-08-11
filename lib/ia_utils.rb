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
end
