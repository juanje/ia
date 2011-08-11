module Ia::Utils
  def pinfo(msg,level = 1)
    puts " " * level + "* ".color(:green) + msg
  end

  def pwarn(msg,level = 1)
    puts " " * level + "* ".color(:yellow) + msg
  end

  def perr(msg,level = 1)
    puts " " * level + "* ".color(:red) + msg
  end
end
