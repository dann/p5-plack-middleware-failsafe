use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Plack::Middleware::Failsafe/],
    style   => 'light';
ok_dependencies();
