use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;

my $app = sub {
    return [ 200, [ 'Content-Type' => 'text/html' ], [ 'hello world' ] ];
};
$app = builder {
    enable "Failsafe";
    $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $res = $cb->(GET "http://localhost/");
    is $res->code, 200;
};

done_testing;

