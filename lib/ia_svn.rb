module Ia::Svn
  
  def svn_scaffold(commit = false)
    dirs = ['doc','doc/calidad','doc/evidencias','doc/gestion_proyecto','doc/entregables','tags','trunk','branches']
    
    dirs.each do |d|
      create_dir(d)
      system("svn add #{d}") if commit == true
    end

    if commit == true
      pinfo("commit de estrucura inicial",2)
      system("svn ci -m 'Estructura inicial'")
    end
  end
end
