use Mojo::Base 'publiccloud::basetest';
use strict;
use warnings;
use testapi;
use utils;
use publiccloud::utils;
use version_utils;

sub run_python_script {
    my $script = shift;
    my $logfile = "output.txt";
    record_info($script, "Running python script: $script");
    assert_script_run("$script");
    assert_script_run("./$script 2>&1 | tee $logfile");
}

sub run {
    my ($self, $args) = @_;

    my $instance = $self->{my_instance} = $args->{my_instance};
    my $provider = $self->{provider} = $args->{my_provider};

    my $sanity_tests_url = data_url("aistack/open-webui-api-test-automation.tar.gz");
    my $test_folder = "open-webui-sanity-tests"

    assert_script_run("curl -O " . $sanity_tests_path);
    assert_script_run("mkdir " . $test_folder)
    assert_script_run("tar -xzvf open-webui-api-test-automation.tar.gz -C ./" . $test_folder)
    assert_script_run("transactional-update pkg install python3");
    assert_script_run("python3 -m venv " . $test_folder . "/venv"); 
    assert_script_run("source " . $test_folder . "/venv/bin/activate");
    assert_script_run("pip3 install -r ./" . $test_folder . "/requirements.txt")
    assert_script_run("pytest --ENV local ./" . $test_folder . "/tests/");
}

sub post_fail_hook {
    my $self = shift;
    $self->cleanup();
    $self->SUPER::post_fail_hook;
}

sub post_run_hook {
    my $self = shift;
    $self->cleanup();
    $self->SUPER::post_run_hook;
}

1;
