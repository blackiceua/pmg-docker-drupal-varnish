Varnish Docker image with VMOD
==============================
Varnish docker image with Varnish VMOD.

Debian Jessie

Varnish 4.1.4 build from source

EXPOSE 6081 6082

VMOD - Varnish module collection by Varnish Software
----------------------------------------------------
https://github.com/varnish/varnish-modules

This is a collection of modules ("vmods") extending Varnish VCL used for
describing HTTP request/response policies with additional capabilities.

Included:

* Simpler handling of HTTP cookies
* Variable support
* Request and bandwidth throttling
* Modify and change complex HTTP headers
* 3.0-style saint mode,
* Advanced cache invalidations, and more.

This image contains the following vmods:
cookie, vsthrottle, header, saintmode, softpurge, tcp, var, xkey
