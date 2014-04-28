require "i18n"
require "vagrant/util/subprocess"
require "vagrant/util/scoped_hash_override"
require "vagrant/util/which"

module VagrantPlugins
  module VSphere
    module Action

      class SyncFolders
        include Vagrant::Util::ScopedHashOverride

        def initialize(app, env)
          @app = app
        end

        def call(env)
          @app.call(env)

          ssh_info = env[:machine].ssh_info

          env[:machine].config.vm.synced_folders.each do |id, data|
            data = scoped_hash_override(data, :vsphere)

            # Ignore disabled shared folders
            next if data[:disabled]

            hostpath  = File.expand_path(data[:hostpath], env[:root_path])
            guestpath = data[:guestpath]

            env[:machine].communicate.upload(hostpath, guestpath)
          end

        end #SyncFolders

      end
    end
  end
end
