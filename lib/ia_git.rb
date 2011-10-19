module Ia::Git

  # Crea un directorio vacio (si no existe ya) y le añade un
  # archivo .gitignore para poder añadirlo al repo Git
  # * dirname(String): nombre del directorio
  def create_empty_dir(dirname='.')
    require 'fileutils'

    create_dir(dirname)

    filename = File.join(dirname, '.gitignore')
    pinfo("\tarchivo #{filename} creado",2) if FileUtils::touch(filename)
  end

  def create_doc_branch
    system("git checkout --orphan doc")

    dirs = [
            'calidad',
            'evidencias',
            'gestion_proyecto',
            'entregables',
           ]

    dirs.each do |dir|
      create_empty_dir(dir)
      system("git add #{dir}")
    end

    pinfo("Creando la estructura de la rama 'doc'",2)
    system("git commit -m 'Estructura inicial de la rama doc'")

    pinfo("Volviendo a la rama master")
    system("git checkout master")
  end

  # Crea dos ramas: master (vacía) y doc (con los directorios de documentación)
  # * projectname(String): nombre del proyecto
  def git_scaffold(projectname)
    pinfo("Creando el repositorio local de git para #{projectname}",2)
    system("git init #{projectname}")
    Dir.chdir projectname

    create_empty_dir
    system("git add .gitignore")

    pinfo("Creando la estructura de la rama 'doc'",2)
    system("git commit -m 'Estructura inicial de la rama master'")

    create_doc_branch
  end

  def git_set_upstream(projectname)
    pinfo("Configurando el repositorio remoto")
    upstream_uri = "git@github.com:Emergya/#{projectname}.git"
    system("git remote add upstream #{upstream_uri}")
    pinfo("upstream -> #{upstream_uri}")
  end
end
