use Module::Build;
my $build = new Module::Build
(
  module_name    => 'Test::DoubleEncodedEntities',
  license        => 'perl',
  requires       => {
                      'Test::Builder' => "0.15" ,
                      'HTML::TokeParser::Simple'   => 0, 
                    },
  recommends     => {
                    },
  build_requires => { 'Test::Builder::Tester' => '1.01'
                   },
  create_makefile_pl => 'traditional',
);
$build->create_build_script;
