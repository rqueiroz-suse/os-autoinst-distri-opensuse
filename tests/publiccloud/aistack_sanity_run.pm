use Mojo::Base 'publiccloud::basetest';
use strict;
use warnings;
use testapi;
use utils;

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

    zypper_call "in python3 python3-pytest";
    # Run python scripts
    run_python_script('pytest --ENV local ' . data_url("aistack/open-webui-api-test-automation/") . 'tests/');
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
