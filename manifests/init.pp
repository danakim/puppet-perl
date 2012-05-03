#
# Class: perl
#
# Class to ease the installation and management of perl modules once they are
# packaged into OS / distro installable packages (eg: rpm, deb etc). The packages
# need to respect the perl{$perl_version}-{$cpan_module_name} naming scheme.
# This class also requires the latest version of the extlookup plugin to be available
# in your puppet master's code base (the version that can read yaml files) and configured
# properly.
#
# Parameters:
#   $version (default: none): <string>
#       This is the perl version to be installed. Without this the puppet run
#       will fail.
#
#   $modules (default: empty): <array>
#       This array must contain the list of perl modules to be installed. The
#       packages should be written on per line, comma separated and the package
#       name and the package version MUST be space delimited. Also, the array
#       must be defined before the "class" definition in the recipe.
#
# Example:
#
#   $modules=[
#       "Image-Magick 1.6.6-1",
#       "Image-Size 1.2.3",
#       "YAML-Tiny 1.41-1"
#   ]
#   perl{"5.8.5-1.el5":
#       modules => $modules
#   }
#
# External data:
#
#   This class also uses a YAML list of default packages to be installed on
#   every node on which this class will be applied on. That list lives in
#   ${extlookup_datadir}/perl/common.yaml. You will also need the perl.yaml file
#   under the same ${extlookup_datadir}/ folder. These files are provided with sample format
#   in this git repo. Also, the ${extlookup_datadir} should  be configured by the extlookup 
#   config file. If you haven't done so already please check:
#   https://github.com/ripienaar/puppet-extlookup
#   http://docs.puppetlabs.com/references/2.6.1/function.html#extlookup
#   If you don't need this functionality comment out the lines below that call this list.
#

define perl (
    $modules = [],
    $default_version = true
    ) {
        $version=$name
        $int_version=regsubst($version,'\.|-.*','','G')

        package { "perl${int_version}":
            ensure   => $version;
        }

        # Comment out the following 3 lines if you don't need the default modules functionality
        # or don't want to / are not able to install the extlookup plugin
        $default_modules = extlookup('perl.yaml','modules')
        perl::modules { $default_modules:
        }
    }

define perl::modules (
    ) {
    $pkg = split($name,'\s+')
    $pkgname = $pkg[0]
    $pkgver  = $pkg[1]
    $perlver = $pkg[2]

    package { "perl${perlver}-${pkgname}":
        ensure   => $pkgver ? {
            "installed" => "installed",
            default => "${pkgver}",
        };
    }
}
