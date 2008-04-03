use inc::Module::Install;
name 'HTTP-MobileAttribute';
all_from 'lib/HTTP/MobileAttribute.pm';

requires 'Class::Component'         => '0.12';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
