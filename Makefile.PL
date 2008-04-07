use inc::Module::Install;
name 'HTTP-MobileAttribute';
all_from 'lib/HTTP/MobileAttribute.pm';

requires 'Class::Component'         => '0.14';

build_requires 'YAML';
build_requires 'Test::Warn';
use_test_base;
auto_include;
WriteAll;
