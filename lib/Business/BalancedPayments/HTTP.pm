package Business::BalancedPayments::HTTP;
{
  $Business::BalancedPayments::HTTP::VERSION = '0.0001';
}
use Moo::Role;

use HTTP::Request::Common qw(GET POST PUT);
use JSON qw(from_json to_json);
use LWP::UserAgent;

has base_url => (
    is      => 'ro',
    default => sub { 'https://api.balancedpayments.com' }
);
has ua => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $ua = LWP::UserAgent->new();
        $ua->timeout(10);
        return $ua;
    },
);

sub get {
    my ($self, $path) = @_;
    return $self->_req(GET $path);
}

sub post {
    my ($self, $path, $params) = @_;
    return $self->_req(POST $path, content => to_json $params);
}

sub put {
    my ($self, $path, $params) = @_;
    return $self->_req(PUT $path, content => to_json $params);
}

# Prefix the path param of the http methods with the base_url
around qw(get post put) => sub {
    my $orig = shift;
    my $self = shift;
    my $path = shift;
    die 'Path is missing' unless $path;
    my $url = $self->_url($path);
    return $self->$orig($url, @_);
};

sub _req {
    my ($self, $req) = @_;
    $req->authorization_basic($self->secret);
    $req->header(content_type => 'application/json');
    my $res = $self->ua->request($req);
    _check_res($res);
    return $res->content ? from_json($res->content) : 1;
}

sub _url {
    my ($self, $path) = @_;
    return $path =~ /^http/ ? $path : $self->base_url . $path;
}

sub _check_res {
    my ($res) = @_;
    die $res unless $res->is_success;
}

1;

__END__
=pod

=head1 NAME

Business::BalancedPayments::HTTP

=head1 VERSION

version 0.0001

=head1 AUTHORS

=over 4

=item *

Naveed Massjouni <naveedm9@gmail.com>

=item *

Khaled Hussein <khaled.hussein@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Crowdtilt, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

