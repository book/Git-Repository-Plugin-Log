use strict;
use warnings;

use Test::More;
use File::Spec;
use Cwd qw( cwd );
use Test::Git;
use Git::Repository 'Log';

has_git('1.5.1');

# test data
{
    our %commit;
    do File::Spec->catfile( 't', 'bundle.pl' );

    sub check_commit {
        my ($log) = @_;
        my $id = $log->commit;
        return if !exists $commit{$id};
        my $commit = $commit{$id};
        is( $log->tree, $commit->{tree}, "commit $id tree" );
        is_deeply( [ $log->parent ], $commit->{parent}, "commit $id parent" );
        is( $log->author,    $commit->{author},    "commit $id author" );
        is( $log->committer, $commit->{committer}, "commit $id committer" );
        is( $log->subject,   $commit->{subject},   "commit $id subject" );
        is( $log->body,      $commit->{body},      "commit $id body" );
        is( $log->extra,     $commit->{extra},     "commit $id extra" );
        is( $log->gpgsig,    $commit->{gpgsig},    "commit $id gpgsig" );
        is_deeply(
            [ $log->mergetag ],
            $commit->{mergetag} || [],
            "commit $id mergetag"
        );
    }

    plan tests => 9 * scalar keys %commit;
}

# setup the environment
my %env = (

    # ensure local configs won't interfere
    GIT_CONFIG_NOSYSTEM => 1,
    XDG_CONFIG_HOME     => undef,
    HOME                => undef,

    # git log will output utf-8
    LC_ALL => 'C',
);

# first create a new empty repository
my $r = test_repository( git => { env => \%env } );

# now load the bundle
my @refs = $r->run(
    bundle => 'unbundle',
    File::Spec->catfile( cwd(), qw( t test.bundle ) )
);

# and update the refs
for my $line (@refs) {
    my ( $sha1, $ref ) = split / /, $line;
    $r->run( 'update-ref', $ref => $sha1 );
}

# test!
my $iter = $r->log('--all');
while ( my $log = $iter->next ) {
    check_commit($log);
}

