# setup the environment
my %env = (

    # ensure local configs won't interfere
    GIT_CONFIG_NOSYSTEM => 1,
    XDG_CONFIG_HOME     => undef,
    HOME                => undef,

    # no locale
    LC_ALL => 'C',

    # author / committer
    GIT_AUTHOR_NAME     => 'Test Author',
    GIT_AUTHOR_EMAIL    => 'test.author@example.com',
    GIT_COMMITTER_NAME  => 'Test Committer',
    GIT_COMMITTER_EMAIL => 'test.committer@example.com',
);
my $r      = test_repository( git => { env => \%env } );
    @badopts = (
        [qw( --pretty=oneline )],
        [qw( --graph )],
        [qw( --format=medium )],
        [qw( --oneline)],
    );