package Business::BalancedPayments::StringableHTTPResponse;
use Moo::Role;
use overload '""' => sub { $_[0]->status_line . "\n" . $_[0]->content };
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Business::BalancedPayments::StringableHTTPResponse

=head1 VERSION

version 0.1500

=head1 AUTHORS

=over 4

=item *

Al Newkirk <al@crowdtilt.com>

=item *

Khaled Hussein <khaled@crowdtilt.com>

=item *

Naveed Massjouni <naveed@crowdtilt.com>

=item *

Will Wolf <will@crowdtilt.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Crowdtilt, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
