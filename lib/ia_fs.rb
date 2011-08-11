module Ia::Fs
  # Comprueba si un directorio dado existe, si no es así lo crea
  # * dirname(String): nombre del directorio
  def create_dir(dirname)
    if FileTest::directory?(dirname)
      pwarn("#{dirname} existe (ignorando)",2)
    else
      pinfo("#{dirname} creado",2) if Dir::mkdir(dirname)
    end
  end
end
