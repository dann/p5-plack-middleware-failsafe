use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;

my $app = sub {
    die 'oops';
};
$app = builder {
    enable "Failsafe";
    $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $res = $cb->(GET "http://localhost/");
    is $res->code, 500;
    like $res->content, qr/Internal/;
};

done_testing;
