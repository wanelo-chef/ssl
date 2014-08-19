include_recipe 'build-essential'
include_recipe 'paths'

helper = SSLHelpers::OpenSSL.new(node)

node['ssl']['openssl']['dependencies'].each do |pkg|
  package pkg
end

remote_file helper.local_tar_file do
  source helper.remote_tar_file
  checksum helper.configured_checksum
end

if helper.configured_checksum != helper.tar_file_checksum
  message = "Your configured checksum (#{helper.configured_checksum})"
  message << " does not match the checksum for #{helper.local_tar_file} (#{helper.tar_file_checksum})."
  raise message
end

execute 'untar openssl' do
  command 'tar xfz %s' % helper.local_tar_file
  cwd Chef::Config[:file_cache_path]
  notifies :run, 'execute[patch openssl]', :immediately
  not_if { ::File.directory?(helper.source_directory) }
end

execute 'patch openssl' do
  command %{find . -name *.pod | xargs sed -i 's/=item \\([[:digit:]]\\)/=item Z<>\\1/'}
  cwd helper.source_directory
  action :nothing
end

execute 'configure openssl' do
  command %q{./config \
    --prefix=%s \
    --openssldir=%s \
    -m32 \
    shared threads \
    -D_REENTRANT} % [
      helper.prefix_dir,
      helper.openssl_dir
    ]
  cwd helper.source_directory
  environment helper.build_environment
  not_if { helper.version_installed? }
end

execute 'make openssl' do
  command 'make'
  cwd helper.source_directory
  environment helper.build_environment
  not_if { helper.version_installed? }
end

execute 'install openssl' do
  command 'make install'
  cwd helper.source_directory
  not_if { helper.version_installed? }
end
