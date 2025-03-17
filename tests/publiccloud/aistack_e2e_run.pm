# SUSE's openQA tests
#
# Copyright 2024 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Basic aistack test

# Summary: This test performs the following actions
#  - Calls AI Stack UI E2E tests
# Maintainer: Rhuan Queiroz <rqueiroz@suse.com>
#

use Mojo::Base 'publiccloud::basetest';
use strict;
use warnings;
use testapi;
use utils;
use publiccloud::utils;
use version_utils;
use transactional qw(process_reboot trup_install trup_shell trup_call);

sub test_flags {
    return {fatal => 1, publiccloud_multi_module => 1};
}

sub run {
    my ($self, $args) = @_;

    my $instance = $self->{my_instance};
    my $provider = $self->{provider};

    my $nvm_url = 'https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh';
    #my $test_archive = get_required_var('OPENWEBUI_E2E_TESTS_ARCHIVE');
    my $test_archive = "open-webui-e2e-tests.tar.gz";
    my $end_to_end_tests_url = data_url("aistack/" . $test_archive);

    my $test_folder = $test_archive;
    $test_folder =~ s/\.tar(\.gz)?$//;

    assert_script_run("curl -o- " . $nvm_url . " | bash");
    assert_script_run('\. "$HOME/.nvm/nvm.sh"');
    assert_script_run("nvm install 22");
    assert_script_run("curl -O " . $end_to_end_tests_url);
    assert_script_run("mkdir " . $test_folder);
    assert_script_run("tar -xzvf " . $test_archive . " -C " . $test_folder);
    assert_script_run("cd " . $test_folder);
    assert_script_run("npm install");
    assert_script_run("npx cypress run");
}

1;
