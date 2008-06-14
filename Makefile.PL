use inc::Module::Install;
name 'HTTP-MobileAttribute';
all_from 'lib/HTTP/MobileAttribute.pm';

requires 'Class::Component'         => '0.17';

features(
    'Plugin::CIDR' => [
        -default => 0,
        recommends('Net::CIDR::MobileJP', 0.11),
    ],
);

test_requires 'YAML';
test_requires 'Test::Warn';
tests 't/*.t t/Plugins/*t';
use_test_base;
auto_include;
WriteAll;
