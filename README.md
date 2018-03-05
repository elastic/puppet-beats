
# beats

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with beats](#setup)
    * [What beats affects](#what-beats-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with beats](#beginning-with-beats)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

A Puppet module for managing and configuring official Elastic beats. Works best with RPM/DEB installs of Beats packages but tries to handle custom installations.

## Setup

### What beats affects

* Elastic stack repository files.
* Each Beats package.
* Each Beats configuration file.
* Each Beats service file.
* Metricbeat module configuration files.

### Setup Requirements

* The [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) Puppet library.

#### Repository management

When using the repository management, the following module dependencies are required:

* Debian/Ubuntu: [Puppetlabs/apt](http://forge.puppetlabs.com/puppetlabs/apt)
* OpenSuSE/SLES: [Darin/zypprepo](https://forge.puppetlabs.com/darin/zypprepo)

### Beginning with beats

Include the `beats` class and pass a list of individual Beats to manage with `beats_manage`:

```puppet
class { 'beats':
  $beats_manage => ['metricbeat','auditbeat','heartbeat','packetbeat']
}
```

## Usage

### Main class

There is very few parameters you should need to customise.  The most useful would be `config_root` which allows you to control where this module expects the individual Beats configuration files to live:

```puppet
class { 'beats':
  beats_manage => ['metricbeat','auditbeat','heartbeat','packetbeat'],
  config_root  => '/opt/beats'
}
```

#### Beats custom configuration

This module recommends using [Hiera](https://puppet.com/docs/puppet/5.3/hiera_intro.html) for configuration data.  You can either specify your complete Beats configuration in Hiera or as a Puppet URL under `beats::<beat_name>::settings`.

Configure in Hiera:

```yaml
beats::auditbeat::settings:
  auditbeat.modules:
  - module: auditd
    audit_rules: |
      -w /etc/group -p wa -k identity
      -w /etc/passwd -p wa -k identity
      -w /etc/gshadow -p wa -k identity
      -w /etc/shadow -p wa -k identity
      -w /etc/security/opasswd -p wa -k identity
      -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access
      -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access
      -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access
      -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access
  - module: file_integrity
    paths:
    - /bin
    - /usr/bin
    - /sbin
    - /usr/sbin
    - /etc
```

Or pass a Puppet URL that will be used as the source of configuration:

```yaml
beats::auditbeat::settings: 'puppet:///somefileshare/auditbeat.yml'
```

### Beats specific usage

#### Metricbeat modules

This class can handle enabling/disabling Metricbeat modules for you.

To enable/disable a list of modules, ensure you manage Metricbeat with this class and then manage the modules in `metricbeat_modules_manage`:

```puppet
class { 'beats':
  beats_manage               => ['metricbeat'],
  metricbeat_modules_manage  => { 'present' => ['docker','kafka'],
                                  'absent'  =>  ['redis'] }
}
```

If you need to define custom settings for a particular module, add those in Hiera under `beats::metricbeat::module_settings`. For example:

```yaml
beats::metricbeat::module_settings:
  docker:
    metricsets: ["container", "cpu", "diskio", "healthcheck", "info", "memory", "network"]
    hosts: ["unix:///var/run/docker.sock"]
    period: 10s
```

## Reference

TBD

## Limitations

TBD

## Development

Please see the [CONTRIBUTING.md](CONTRIBUTING.md) file for instructions regarding development environments and testing.
