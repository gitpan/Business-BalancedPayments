package Business::BalancedPayments::StringableHTTPResponse;
use Moo::Role;
use overload '""' => sub { $_[0]->status_line . "\n" . $_[0]->content };
1;

__END__

=pod

=head1 NAME

Business::BalancedPayments::StringableHTTPResponse

=head1 VERSION

version 0.1200

=head1 AUTHORS

=over 4

=item *

Khaled Hussein <khaled.hussein@gmail.com>

=item *

Naveed Massjouni <naveedm9@gmail.com>

=item *

Will Wolf<throughnothing@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Crowdtilt, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
