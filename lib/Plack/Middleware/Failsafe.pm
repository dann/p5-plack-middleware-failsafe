package Plack::Middleware::Failsafe;
use strict;
use warnings;
use parent qw/Plack::Middleware/;

use IO::File;
use Plack::Util;
use Plack::Util::Accessor qw( error_template_path logger);

our $VERSION = '0.01';

sub call {
    my ( $self, $env ) = @_;

    my $res = eval { $self->app->($env); };

    if ( my $e = $@ ) {
        $self->log_exception( $env, $e );
        $res = [
            500,
            [ 'Content-Type' => 'text/html', ],
            [ $self->failsafe_response_content($e) ]
        ];
    }
    return $res;
}

sub log_exception {
    my ( $self, $env, $e ) = @_;

    my $logger = $self->logger || sub { $env->{'psgi.errors'}->print($e) };
    $logger->($e);
}

sub failsafe_response_content {
    my $self = shift;

    my $error_template_path = $self->error_template_path;
    if ( $error_template_path && -f $error_template_path ) {
        return $self->_error_template_file($error_template_path);
    }
    else {
        return $self->_default_error_message();
    }
}

sub _error_template_file {
    my ( $self, $file ) = @_;
    return IO::File->new( $file, 'r' );
}

sub _default_error_message {
    my ( $self, $e ) = @_;
    my $error_message
        = "<html><body><h1>500 Internal Server Error</h1>"
        . "If you are the administrator of this website, then please read this web "
        . "application's log file to find out what went wrong.</body></html>";
    return $error_message;
}

1;

__END__

=encoding utf-8

=head1 NAME

Plack::Middleware::Failsafe -

=head1 SYNOPSIS

  use Plack::Builder;
  use Plack::Middleware::Failsafe;

  my $app = builder {
      enable "Failsafe", error_template_path => "/myapp/errors/500.html";
      sub {
        die 'error';    
      };
  };


=head1 DESCRIPTION

Plack::Middleware::Failsafe is usually the top-most middleware in the plack
middleware chain. It returns the underlying middleware's response, but if
the underlying middle raises an exception then Failsafe will log the
exception into the file, and will attempt to return an error message response. 

=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/

=head1 AUTHOR

dann E<lt>techmemo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
