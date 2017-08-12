This directory contains resources designed to be used with the web
application software when the web application is running inside a
Docker container.

There are a few configuration files that may not work properly when
running inside a Docker container unless they are changed, such as the
database configuration file.

This README document describes the changes made to these files.

## database.yml (=> /config/database.yml)

The default database.yml is optimized for multiple environments (i.e.
you can use the same application instance to code and test using the
`development` and `test` environments).

On Docker images you don't usually want that behaviour, but instead
a single running environment, usually configured through environment
variables such as RAILS\_ENV, DATABASE\_HOST and such.