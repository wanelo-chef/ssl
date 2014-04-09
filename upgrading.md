Updating OpenSSL
================

0-day exploits in cryptography libraries suck, often much worse
than exploits in other software. One of the key problems is that
most of the software we use in the open source community outsources
cryptography to other open source software. When a vulnerability
is exposed in the linked libraries, everything depending on it
becomes vulnerable.

When a new exploit is exposed and a solution released by the owners
of the library, it should be released to effected servers as
quickly as possible.

## What do I do when a massive 0-day exploit is revealed in OpenSSL?

* panic
* scream a lot
* curse the bug
* curse the fact that the exploit was just revealed
* pretend everything is okay, and that none of your systems are effective
* panic some more
* sigh, calm down, get to work. Make some coffee, you're going to be
  awake for a while.

## Am I vulnerable?

For the sake of example, let us look at the Heartbleed vulnerability
in OpenSSL. It effects all versions of OpenSSL 1.0.1 inclusive of
1.0.1f.

This vulnerability was particularly troublesome, as it exposed
an attack vector to extract any resident memory in a linked process,
in 64k chunks. Attackers on the internet could read memory from Nginx,
for instance, retrieving HTTPS certs, usernames and passwords that had
not yet been freed, etc.

How do we tell if Nginx is using a vulnerable version of OpenSSL?

First let's ask openssl what version is installed, understanding that
this is highly dependent on how OpenSSL was installed and the current
PATH. Even if this returns a safe version of the library, there may be
multiple versions installed in different paths.

```bash
openssl version
> OpenSSL 1.0.1f 6 Jan 2014
```

Now let's check nginx:

```bash
ldd `which nginx`
> libssl.so.1.0.0 => /opt/local/lib/libssl.so.1.0.0

strings /opt/local/lib/libssl.so.1.0.0 | grep '^OpenSSL'
> OpenSSL 1.0.1f 6 Jan 2014
```

For different libraries, the search and grep might require slightly
different parameters. Be stubborn.

## Package or sources?

Packages have the benefit of installing quickly and having a reasonable
chance of working out of the box. Compiling from source takes longer
and may be error prone on certain platform, but does not depend on
another company for the release cycle.

For stable software reasonably considered to be safe, recipes to install
via packages may be prefered. Having a recipe to compile from sources is
ideal for critical libraries, however, as it will allow for much speedier
patching in case of something like Heartbleed.

## What version should I upgrade to?

First of all, versions are very important. If Nginx is linked against
1.0.1f, then 1.0.1.g **may** be an in-place upgrade. Upgrading from 1.0.1f
to 1.0.2 should be treated much more carefully, and very likely would
require recompiling Nginx for source.

If the version of the library is different throughout your infrastructure,
then your roll-out plan should include contingencies for each version.

* which versions are vulnerable?
* which versions need to be patched?
* are some versions fine they way they are, and can be left alone?

In the case of Heartbleed, OpenSSL 0.9.8x was not vulnerable, and could
be left in place to avoid having to recompile associated software. Only
when version 1.0.1 was detected should OpenSSL be recompiled.

## How do I upgrade?

Ideally, upgrading a system library should be an in-place switch to a
new minor or patch version, then a restart of linked software. If
possible, a cold reboot is the best way to prove that nothing keeps
the old library around in memory.

... to be continued
