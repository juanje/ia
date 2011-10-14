module Ia::Queca

  # Ejecuta ia queca --init-remote PROJ en QuecaSDK y depues
  # configura el repo de trabajo para poder hacer push a QuecaSDK
  def queca_prepare_deploy(name,remote)
    pinfo("Ejecutando ia queca --initremote en #{remote}")
    if system("ping -c 1 #{remote} > /dev/null")
      system("ssh user@#{remote} '~/.local/ia/bin/ia --name=#{name} queca --initremote'")
      queca_init_host_git(name,remote)
    else
      perr("El servidor #{remote} no responde")
    end
  end

  # Inicializa un git vacio y configurado para permiter push de otro repo
  # además añade un hook que actualiza al hacer un push desde el repo de trabajo (deploy)
  def queca_init_remote_git(name)
    proj_path = "/var/www/projects"
    system("mkdir #{proj_path}/#{name} && cd #{proj_path}/#{name} && git init && git config receive.denycurrentbranch ignore")

    pinfo("Git iniciado y configurado en #{proj_path}/#{name}")

    hook = %{#!/home/user/.rvm/rubies/ruby-1.9.2-p290/bin/ruby

# Aside from removing Ruby on Rails specific code this is taken verbatim from
# mislav's git-deploy (http://github.com/mislav/git-deploy) and it's awesome
#  - Ryan Florence (http://ryanflorence.com)
#
# https://gist.github.com/585746
#
# Install this hook to a remote repository with a working tree, when you push
# to it, this hook will reset the head so the files are updated

if ENV['GIT_DIR'] == '.'
  # this means the script has been called as a hook, not manually.
  # get the proper GIT_DIR so we can descend into the working copy dir;
  # if we don't then `git reset --hard` doesn't affect the working tree.
  Dir.chdir('..')
  ENV['GIT_DIR'] = '.git'
end

cmd = %(bash -c "[ -f /etc/profile ] && source /etc/profile; echo $PATH")
envpath = IO.popen(cmd, 'r') { |io| io.read.chomp }
ENV['PATH'] = envpath

# find out the current branch
head = `git symbolic-ref HEAD`.chomp
# abort if we're on a detached head
exit unless $?.success?

oldrev = newrev = nil
null_ref = '0' * 40

# read the STDIN to detect if this push changed the current branch
while newrev.nil? and gets
  # each line of input is in form of "<oldrev> <newrev> <refname>"
  revs = $_.split
  oldrev, newrev = revs if head == revs.pop
end

# abort if there's no update, or in case the branch is deleted
exit if newrev.nil? or newrev == null_ref

# update the working copy
`umask 002 && git reset --hard`}

    hook_file = "#{proj_path}/#{name}/.git/hooks/post-receive"
    file = File.new(hook_file, "w")
    file.write(hook)
    file.close

    system("chmod +x #{proj_path}/#{name}/.git/hooks/post-receive")

    pinfo("Hook de deploy creado")

    pinfo("#{proj_path}/#{name} iniciado")
  end

  def queca_init_host_git(name, remote="queca.lan")
    pinfo("Preparando repositorio de trabajo")
    system("git remote add #{remote} ssh://user@#{remote}/var/www/projects/#{name}")
    pinfo("Ya puedes ejecutar git push #{remote} para hacer un despliegue")
  end

  # sincronizamos BBDD
  def queca_syncdb(source, target)
    pinfo("Ejecutando sync ddbb : #{source} => #{target}")
    system("drush sql-sync @#{source} @#{target}")
    pinfo("Sync DDBB temrinado")
  end

  # Sincronizamos el directorio files
  def queca_syncfiles(source, target)
    pinfo("Ejecutando sync files : #{source} => #{target}")
    system("drush rsync @#{source}:%files @#{target}:%files")
    pinfo("Sync Files temrinado")
  end
end
