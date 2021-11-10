# Check for the user or system global verison
# If we pass in a user check that users global

provides :pyenv_global
unified_mode true
include Chef::Pyenv::ScriptHelpers

property :pyenv_version,
          String,
          name_property: true

property :user,
          String

property :prefix,
          String,
          default: lazy { root_path }

action :create do
  pyenv_script 'globals' do
    code "pyenv global #{new_resource.pyenv_version}"
    user new_resource.user if new_resource.user
    action :run
    not_if { current_global_version_correct? }
  end
end

action_class do
  include Chef::Pyenv::ScriptHelpers

  def current_global_version_correct?
    current_global_version == new_resource.pyenv_version
  end

  def current_global_version
    version_file = ::File.join(new_resource.root_path, 'version')

    ::File.exist?(version_file) && ::IO.read(version_file).chomp
  end
end
