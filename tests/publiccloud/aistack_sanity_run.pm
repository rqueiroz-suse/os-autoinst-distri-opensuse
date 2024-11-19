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

    my $sanity_tests_path = data_url("aistack/open-webui-api-test-automation/");

    assert_script_run("transactional-update pkg install python3");
    assert_script_run("python3 -m venv venv"); 
    assert_script_run("source venv/bin/activate");
    assert_script_run("pip3 install -r " . $sanity_tests_path . "/requirements.txt");
    assert_script_run("pytest --ENV local " . $sanity_tests_path . "/tests/");
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
