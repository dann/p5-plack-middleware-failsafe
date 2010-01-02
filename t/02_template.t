use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use FindBin;

my $app = sub {
    die 'oops';
};
$app = builder {
    enable "Failsafe", error_template_path => "$FindBin::Bin/errors/500.html";
    $app;
};

test_psgi
    app    => $app, client => sub {
    my $cb  = shift;
    my $res = $cb->( GET "http://localhost/" );
    is $res->code, 500;
};

done_testing;

