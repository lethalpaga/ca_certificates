ca_certificates Cookbook
========================

This cookbook provides the ability to manage the system-level trusted certificate authorities. 
The primary use case would be to add your on internal corporate certificate authority as trusted.

If you run your own Certificate Authority (CA), you will need to install your certificate on each of the
machines you would like to use certificates from that CA. Debian and Red Hat both provide different ways of
adding trusted Certificate Authority Root Certificates to their systems. The goal of this cookbook is to
abstract that in a way that is easy to manage with chef.

For more detailed information see Red Hat's `update-ca-trust` and Debian's `update-ca-certificates`.

## Platforms:

The following platforms and versions are tested and supported using
[test-kitchen](http://kitchen.ci/)

* Ubuntu 14.04
* Debian 7.6
* CentOS 6.6, 7.0

Attributes
==========

* `node['ca_certificates']['path']` - path to ca root certificate storage

Tests
=====

The following commands will run the tests:

```
bundle install
bundle exec rubocop
bundle exec foodcritic .
bundle exec rspec
bundle exec kitchen test default-ubuntu-1404
bundle exec kitchen test default-centos-66
```

The above will do ruby style ([rubocop](https://github.com/bbatsov/rubocop)) and cookbook style ([foodcritic](http://www.foodcritic.io/)) checks followed by rspec unit tests ensuring proper cookbook operation. Integration tests will be run next on two separate linux platforms (Ubuntu 14.04 LTS Precise 64-bit and CentOS 6.5). Please run the tests on any pull requests that you are about to submit and write tests for defects or new features to ensure backwards compatibility and a stable cookbook that we can all rely upon.

## Running tests continuously with guard

This cookbook is also setup to run the checks while you work via the [guard gem](http://guardgem.org/).

```
bundle install
bundle exec guard start
```

ChefSpec LWRP Matchers
======================

The cookbook exposes a chefspec matcher to be used by wrapper cookbooks to test the cookbooks LWRP. See `library/matchers.rb` for basic usage.


License and Authors
===================

* Author:: Sander van Zoest <cookbooks@vanzoest.com>
* Copyright:: 2015, Alexander van Zoest

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
