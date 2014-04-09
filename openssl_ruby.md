Analyzing current OpenSSL used by Ruby
======================================

Assuming a Ruby process running in a service `sidekiq`

```bash
svcs -p sidekiq

STATE          STIME    FMRI
online         17:01:25 svc:/application/management/sidekiq:default
               17:01:25    90815 ruby
               17:01:25    90816 ruby
```

We can look at the files mapped in the process memory

```bash
sudo pmap 90815

...
FFFFFD7FFADF0000          8K rw---  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/zlib.so
FFFFFD7FFAE00000         16K r-x--  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/digest.so
FFFFFD7FFAE13000          8K rw---  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/digest.so
FFFFFD7FFAE20000        356K r-x--  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/openssl.so
FFFFFD7FFAE88000         12K rw---  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/openssl.so
FFFFFD7FFAE8B000          4K rw---  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/openssl.so
FFFFFD7FFAE90000        220K r-x--  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/date_core.so
FFFFFD7FFAED6000          8K rw---  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/date_core.so
FFFFFD7FFAED8000          8K rw---  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/date_core.so
FFFFFD7FFAEE0000         24K r-x--  /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x8
...
```

Now we can look at how the dynamic library used by Ruby is linked

```bash
ldd /opt/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/x86_64-solaris2.11/openssl.so
        libruby.so.2 =>  /opt/rbenv/versions/2.0.0-p353/lib/libruby.so.2
        libsocket.so.1 =>        /lib/64/libsocket.so.1
        libnsl.so.1 =>   /lib/64/libnsl.so.1
        libssl.so.1.0.0 =>       /opt/local/lib/libssl.so.1.0.0
        libcrypto.so.1.0.0 =>    /opt/local/lib/libcrypto.so.1.0.0
        libpthread.so.1 =>       /lib/64/libpthread.so.1
        librt.so.1 =>    /lib/64/librt.so.1
        libdl.so.1 =>    /lib/64/libdl.so.1
        libcrypt.so.1 =>         /usr/lib/64/libcrypt.so.1
        libm.so.2 =>     /lib/64/libm.so.2
        libc.so.1 =>     /lib/64/libc.so.1
        libssp.so.0 =>   /opt/local/gcc47/x86_64-sun-solaris2.11/lib/amd64/libssp.so.0
        libgcc_s.so.1 =>         /opt/local/gcc47/x86_64-sun-solaris2.11/lib/amd64/libgcc_s.so.1
        libmp.so.2 =>    /lib/64/libmp.so.2
        libmd.so.1 =>    /lib/64/libmd.so.1
        libgen.so.1 =>   /lib/64/libgen.so.1
```

Here we see that `libssl.so.1.0.0` is being used from `/opt/local/lib`. Now
we can look for the version of libssl being used.

```bash
strings /opt/local/lib/libssl.so.1.0.0 | grep OpenSSL
...
OpenSSL 1.0.1g 7 Apr 2014
```
