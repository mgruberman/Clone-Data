use ExtUtils::MakeMaker;
WriteMakefile(
    dist => {
        COMPRESS => 'gzip -9v',
        SUFFIX => '.gz',
    },
    VERSION_FROM => 'Data.pm',
    NAME => 'Clone::Data',
);

