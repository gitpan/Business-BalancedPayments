package Business::BalancedPayments::Base;
use Moo::Role;
with 'WebService::Client';

our $VERSION = '1.0500'; # VERSION

use Carp qw(croak);
use HTTP::Request::Common qw(GET POST);
use JSON qw(encode_json);

requires qw(_build_marketplace _build_uris);

has '+base_url' => (is => 'ro', default => 'https://api.balancedpayments.com');

has secret => (is => 'ro', required => 1);

has uris => (is => 'ro', lazy => 1, builder => '_build_uris' );

has marketplace => (is => 'ro', lazy => 1, builder => '_build_marketplace');

around req => sub {
    my ($orig, $self, $req, @rest) = @_;
    $req->authorization_basic($self->secret);
    return $self->$orig($req, @rest);
};

sub get_card {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    return $self->get($self->_uri('cards', $id));
}

sub create_card {
    my ($self, $card) = @_;
    croak 'The card param must be a hashref' unless ref $card eq 'HASH';
    return $self->post($self->_uri('cards'), $card);
}

sub get_customer {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    return $self->get($self->_uri('customers', $id));
}

sub create_customer {
    my ($self, $customer) = @_;
    $customer ||= {};
    croak 'The customer param must be a hashref' unless ref $customer eq 'HASH';
    return $self->post($self->_uri('customers'), $customer);
}

sub get_debit {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    return $self->get($self->_uri('debits', $id));
}

sub get_bank_account {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    return $self->get($self->_uri('bank_accounts', $id));
}

sub create_bank_account {
    my ($self, $bank) = @_;
    croak 'The bank account must be a hashref' unless ref $bank eq 'HASH';
    return $self->post($self->_uri('bank_accounts'), $bank);
}

sub get_credit {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    return $self->get($self->_uri('credits', $id));
}

sub log {
    my ($self, $msg) = @_;
    return unless $self->logger;
    $self->logger->DEBUG("BP: $msg");
}

sub _uri {
    my ($self, $key, $id) = @_;
    return $id if $id and $id =~ /\//; # in case a uri was passed in
    return $self->uris->{$key} . ( defined $id ? "/$id" : '' );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Business::BalancedPayments::Base

=head1 VERSION

version 1.0500

=head1 AUTHORS

=over 4

=item *

Ali Anari <ali@tilt.com>

=item *

Khaled Hussein <khaled@tilt.com>

=item *

Naveed Massjouni <naveed@tilt.com>

=item *

Al Newkirk <al@tilt.com>

=item *

Will Wolf <will@tilt.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Crowdtilt, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
