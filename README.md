ssl cookbook
============

Install SSL libraries from sources. Like you do.

## Recipes

* openssl

## OpenSSL Usage

### Source mirrors

This cookbook uses the openssl website for source files. This
is not particularly safe or stable.

First of all, grab a copy of the source tarball and stick it
into your own mirror. Keeping source caches in Manta is fantastic
and easy, if you have an account:

```bash
mlogin
......
cd ~
wget https://www.openssl.org/source/openssl-1.0.1g.tar.gz
mput -f openssl-1.0.1g.tar.gz ~~/public/path/to/my/source/caches/
exit
```

Now somewhere in your Chef repository set the following node
attribute:

```ruby
node['ssl']['openssl']['mirror'] =
  'https://us-east.manta.joyent.com/my-account/public/path/to/my/source/caches'
```

### Installing OpenSSL

```ruby
include_recipe 'ssl::openssl'
```

This will first install openssl via the local package system, then compile the
specified version over the package.

**Attributes:**
```ruby
node['ssl']['openssl']['version'] = '1.0.1g'
node['ssl']['openssl']['sha1'] = '...'
```

This assumes that the file name matches `openssl-%{version}.tar.gz`.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
7. Tag @sax on any pull requests, to make sure I see it!
