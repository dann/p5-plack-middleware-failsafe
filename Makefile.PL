use inc::Module::Install;
name 'Plack-Middleware-Failsafe';
all_from 'lib/Plack/Middleware/Failsafe.pm';

requires( 'Plack' => 0, );

test_requires( 'Test::More' => 0, );

use_test_base;
auto_include;
WriteAll;
