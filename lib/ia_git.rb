module Ia::Git

  # Crea un directorio vacio (si no existe ya) y le añade un
  # archivo .gitignore para poder añadirlo al repo Git
  # * dirname(String): nombre del directorio
  def create_empty_dir(dirname)
    require 'fileutils'
    create_dir(dirname)
    filename = File.join(dirname, '.gitignore')
    pinfo("\t#{filename} añadido",2) if FileUtils::touch(filename)
  end

  # Crea una estructura de directorios definida en el array "dirs"
  def git_scaffold
    pinfo("Creando el repositorio local de git",2)
    system("git init")

    dirs = ['doc',
            'doc/calidad',
            'doc/evidencias',
            'doc/gestion_proyecto',
            'doc/entregables',
            'trunk']

    dirs.each do |d|
      create_empty_dir(d)
      system("git add #{d}")
    end

    pinfo("commit de estrucura inicial",2)
    system("git commit -m 'Estructura inicial'")
  end
end
