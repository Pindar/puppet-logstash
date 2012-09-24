# = Class: logstash
#
# This is the main logstash class
#
#
# == Parameters
#
# Module Specific params
#
# [*run_mode*]
#   Define logstash run mode: agent web . Default: agent
#
# [*run_options*]
#   The explicit options to pass to the monolithic jar when starting it.
#   This value is appended to exiting -f and -l parameters
#
# [*install_prerequisites*]
#   Set to false if you don't want install this module's prerequisites.
#   (It may be useful if the resources provided the prerequisites are already
#   managed by some other modules). Default: true
#   Prerequisites are based on Example42 modules set.
#
# [*create_user*]
#   Set to true if you want the module to create the process user of logstash
#   (as defined in $logstagh::process_user). Default: true
#   Note: User is not created when $logstash::install is package
#  
# [*version*]
#   The logstash version you want to install. The default install_source is
#   calculated according to it.
#
# [*install*]
#   Kind of installation to attempt:
#     - package : Installs logstash using the OS common packages
#     - source  : Installs logstash downloading and extracting a specific
#                 tarball or zip file
#     - puppi   : Installs logstash tarball or file via Puppi, creating the
#                 "puppi deploy logstash" command
#   Can be defined also by the variable $logstash_install
#
# [*install_source*]
#   The URL from where to retrieve the source jar.
#   Used if install => "source" or "puppi"
#   Default is from upstream developer site. Update the version when needed.
#   Can be defined also by the variable $logstash_install_source
#
# [*install_destination*]
#   The base path where to place the jar.
#   Used if install => "source" or "puppi"
#   Can be defined also by the variable $logstash_install_destination
#
# [*install_precommand*]
#   A custom command to execute before installing the source tarball/zip.
#   Used if install => "source" or "puppi"
#   Check logstash/manifests/params.pp before overriding the default settings
#   Can be defined also by the variable $logstash_install_precommand
#
# [*install_postcommand*]
#   A custom command to execute after installing the source tarball/zip.
#   Used if install => "source" or "puppi"
#   Check logstash/manifests/params.pp before overriding the default settings
#   Can be defined also by the variable $logstash_install_postcommand
#
# [*init_script_template*]
#   The template to use to create the init script.
#   Use this to customize the default file.
#
# [*upstart_template*]
#   The template to use to create the upstart conf file.
#   Use this to customize the default file.
#   Note that upstart and init_script are alternative.
#
# [*use_upstart*]
#   If to use upstart to manage the service. Default: true
#
# [*source_dir_patterns*]
#   Path (in format: puppet:///modules/path) where that contains custom patterns
#   to use with logstash. You have to refer to it in your grok stanzas as:
#   patterns_dir => "<%= scope.lookupvar('logstash::logstash_dir') %>/patterns"
#   Default blank. Stadard patterns are used.
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, logstash class will automatically "include $my_class"
#   Can be defined also by the variable $logstash_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, logstash main config file will have the param:
#   source => $source
#   Can be defined also by the variable $logstash_source
#
# [*source_dir*]
#   If defined, the whole logstash configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the variable $logstash_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the variable $logstash_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, logstash main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the variable $logstash_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the variable $logstash_options
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the variable $logstash_absent
#
# [*service_autorestart*]
#   Automatically restarts the logstash service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $logstash_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $logstash_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the variables $logstash_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for logstash checks
#   Can be defined also by the variables $logstash_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the variables $logstash_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the variables $logstash_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the variables $logstash_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $logstash_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for logstash port(s)
#   Can be defined also by the (top scope) variables $logstash_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling logstash. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $logstash_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $logstash_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the variables $logstash_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the variables $logstash_audit_only
#   and $audit_only
#
# Default class params - As defined in logstash::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of logstash package
#
# [*service*]
#   The name of logstash service
#
# [*service_status*]
#   If the logstash service init script supports status argument
#
# [*process*]
#   The name of logstash process
#
# [*process_args*]
#   The name of logstash arguments. Used by puppi and monitor.
#   Used only in case the logstash process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user logstash runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $logstash_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $logstash_protocol
#
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include logstash"
# - Call logstash as a parametrized class
#
# See README for details.
#
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#
class logstash (
  $run_mode              = params_lookup( 'run_mode' ),
  $run_options           = params_lookup( 'run_options' ),
  $install_prerequisites = params_lookup( 'install_prerequisites' ),
  $create_user           = params_lookup( 'create_user' ),
  $version               = params_lookup( 'version' ),
  $install               = params_lookup( 'install' ),
  $install_source        = params_lookup( 'install_source' ),
  $install_destination   = params_lookup( 'install_destination' ),
  $install_precommand    = params_lookup( 'install_precommand' ),
  $install_postcommand   = params_lookup( 'install_postcommand' ),
  $init_script_template  = params_lookup( 'init_script_template' ),
  $upstart_template      = params_lookup( 'upstart_template' ),
  $use_upstart           = params_lookup( 'use_upstart' ),
  $source_dir_patterns   = params_lookup( 'source_dir_patterns' ),
  $my_class              = params_lookup( 'my_class' ),
  $source                = params_lookup( 'source' ),
  $source_dir            = params_lookup( 'source_dir' ),
  $source_dir_purge      = params_lookup( 'source_dir_purge' ),
  $template              = params_lookup( 'template' ),
  $service_autorestart   = params_lookup( 'service_autorestart' , 'global' ),
  $options               = params_lookup( 'options' ),
  $absent                = params_lookup( 'absent' ),
  $disable               = params_lookup( 'disable' ),
  $disableboot           = params_lookup( 'disableboot' ),
  $monitor               = params_lookup( 'monitor' , 'global' ),
  $monitor_tool          = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target        = params_lookup( 'monitor_target' , 'global' ),
  $puppi                 = params_lookup( 'puppi' , 'global' ),
  $puppi_helper          = params_lookup( 'puppi_helper' , 'global' ),
  $firewall              = params_lookup( 'firewall' , 'global' ),
  $firewall_tool         = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src          = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst          = params_lookup( 'firewall_dst' , 'global' ),
  $debug                 = params_lookup( 'debug' , 'global' ),
  $audit_only            = params_lookup( 'audit_only' , 'global' ),
  $package               = params_lookup( 'package' ),
  $service               = params_lookup( 'service' ),
  $service_status        = params_lookup( 'service_status' ),
  $process               = params_lookup( 'process' ),
  $process_args          = params_lookup( 'process_args' ),
  $process_user          = params_lookup( 'process_user' ),
  $config_dir            = params_lookup( 'config_dir' ),
  $config_file           = params_lookup( 'config_file' ),
  $config_file_mode      = params_lookup( 'config_file_mode' ),
  $config_file_owner     = params_lookup( 'config_file_owner' ),
  $config_file_group     = params_lookup( 'config_file_group' ),
  $config_file_init      = params_lookup( 'config_file_init' ),
  $pid_file              = params_lookup( 'pid_file' ),
  $data_dir              = params_lookup( 'data_dir' ),
  $log_dir               = params_lookup( 'log_dir' ),
  $log_file              = params_lookup( 'log_file' ),
  $port                  = params_lookup( 'port' ),
  $protocol              = params_lookup( 'protocol' )
  ) inherits logstash::params {

  ### VARIABLES

  ### Variables reduced to booleans
  $bool_install_prerequisites=any2bool($install_prerequisites)
  $bool_use_upstart=any2bool($use_upstart)
  $bool_create_user=any2bool($create_user)
  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $logstash::bool_absent ? {
    true  => 'absent',
    false => 'present',
  }

  $manage_service_enable = $logstash::bool_disableboot ? {
    true    => false,
    default => $logstash::bool_disable ? {
      true    => false,
      default => $logstash::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $logstash::bool_disable ? {
    true    => 'stopped',
    default =>  $logstash::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $logstash::bool_service_autorestart ? {
    true    => Service[logstash],
    false   => undef,
  }

  $manage_file = $logstash::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $logstash::bool_absent == true
  or $logstash::bool_disable == true
  or $logstash::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $logstash::bool_absent == true
  or $logstash::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $logstash::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $logstash::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $logstash::source ? {
    ''        => undef,
    default   => $logstash::source,
  }

  $manage_file_content = $logstash::template ? {
    ''        => undef,
    default   => template($logstash::template),
  }

  $manage_source_dir = $logstash::source_dir ? {
    ''        => undef,
    default   => $logstash::source_dir,
  }

  ### Calculations of variables whose value depends on different params
  $real_install_source = $logstash::install_source ? {
    ''      => "${logstash::params::base_install_source}/logstash-${logstash::version}-monolithic.jar",
    default => $logstash::install_source,
  }

  $logstash_dir = $logstash::install ? {
    package => "${logstash::params::base_data_dir}",
    default => "${logstash::install_destination}/logstash",
  }

  $real_data_dir = $logstash::data_dir ? {
    ''      => $logstash::install ? {
      package => $logstash::params::base_data_dir,
      default => "${logstash::logstash_dir}/data",
    },
    default => $logstash::data_dir,
  }

  ### Managed resources
  # Installation is managed in a dedicated class
  require logstash::install

  # Service is managed in a dedicated class
  include logstash::service

  if ($logstash::source or $logstash::template) {
    file { 'logstash.conf':
      ensure  => $logstash::manage_file,
      path    => $logstash::config_file,
      mode    => $logstash::config_file_mode,
      owner   => $logstash::config_file_owner,
      group   => $logstash::config_file_group,
      require => Class['logstash::install'],
      notify  => $logstash::manage_service_autorestart,
      source  => $logstash::manage_file_source,
      content => $logstash::manage_file_content,
      replace => $logstash::manage_file_replace,
      audit   => $logstash::manage_audit,
    }
  }

  # The whole logstash configuration directory can be recursively overriden
  if $logstash::source_dir
  or $logstash::install != 'package' {
    file { 'logstash.dir':
        ensure  => directory,
        path    => $logstash::config_dir,
        require => Class['logstash::install'],
        owner   => $logstash::process_user,
        group   => $logstash::process_group,
        notify  => $logstash::manage_service_autorestart,
        source  => $logstash::manage_source_dir,
        recurse => true,
        purge   => $logstash::bool_source_dir_purge,
        replace => $logstash::manage_file_replace,
        audit   => $logstash::manage_audit,
      }
    }

  ### Include prerequisites class
  if $logstash::bool_install_prerequisites {
    include logstash::prerequisites
  }

  ### Include custom class if $my_class is set
  if $logstash::my_class {
    include $logstash::my_class
  }

  ### Provide puppi data, if enabled ( puppi => true )
  if $logstash::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'logstash':
      ensure    => $logstash::manage_file,
      variables => $classvars,
      helper    => $logstash::puppi_helper,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $logstash::bool_debug == true {
    file { 'debug_logstash':
      ensure  => $logstash::manage_file,
      path    => "${settings::vardir}/debug-logstash",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
