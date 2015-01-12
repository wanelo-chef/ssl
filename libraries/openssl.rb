module SSLHelpers
  # SSLHelpers::OpenSSL
  #
  # Helper class for wrapping up logic used by the
  # openssl recipe.
  #
  class OpenSSL
    include Chef::Mixin::ShellOut

    attr_reader :node

    def initialize(node)
      @node = node
    end

    def build_environment
      {
        'CFLAGS' => 'O2 -pipe -O2 -I/opt/local/include -I/usr/include',
        'LDFLAGS' => '-L/opt/local/lib -Wl,-R/opt/local/lib'
      }
    end

    def local_tar_file
      [Chef::Config[:file_cache_path], tar_file].join('/')
    end

    def openssl_dir
      [node['paths']['etc_dir'], 'openssl'].join('/')
    end

    def prefix_dir
      node['paths']['prefix_dir']
    end

    def remote_tar_file
      [config['mirror'], tar_file].join('/')
    end

    def source_directory
      [Chef::Config[:file_cache_path], source_directory_name].join('/')
    end

    def tar_file_checksum
      config['sha1']
    end

    def version_installed?
      current_version == config['version']
    end

    private

    def config
      node['ssl']['openssl']
    end

    def current_version
      shell_out('openssl version').stdout.split[1]
    end

    def source_directory_name
      format('openssl-%s', config['version'])
    end

    def tar_file
      format('openssl-%s.tar.gz', config['version'])
    end
  end
end
