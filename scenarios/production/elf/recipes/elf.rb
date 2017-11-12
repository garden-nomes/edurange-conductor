script "install_elf" do
  interpreter "bash"
  user "root"
  cwd "/tmp"

  code <<-EOH
  cd /tmp
  git clone https://github.com/edurange/scenario-elf
  cd scenario-elf
  ./install
  cd /tmp
  touch test-file
  EOH

  not_if "test -e /tmp/test-file"
end