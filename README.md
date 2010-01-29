The Problem
===========

`SmartCookieStore` is a fix for the current (as of 2.3.5) Rails
`CookieStore`. The problem with the `CookieStore` as is, is that it
sends a `Set-Cookie` header whenever the `session` (including the `flash`)
is accessed. This means that whenever you have a call to `flash[:notice]`
in your layout file, a `Set-Cookie` will be sent to the client. Even if
the session/flash is completely empty! This is problematic when you want
to use something like Varnish. By default it doesn't cache pages that
send a header (and rightly so).

The Solution
============

This plugin adds a new `CookieStore`, the `SmartCookieStore` that checks
if the session is empty and only sends the `Set-Cookie` header when the
session is not empty.

Usage
=====

Install as a gem:
-----------------

    gem install smart_cookie_store

And add it to your `config/environment.rb`:

    config.gem "smart_cookie_store"

Install as a plugin:
--------------------

    script/plugin install git://github.com/msales/smart_cookie_store.git

Configuration
-------------

The configure your app to use the new `SmartCookieStore`:

    ActionController::Base.session_store = :smart_cookie_store

Compatibility
=============

This is an initial release that was only tested on Rails 2.3.5!

To Do
=====

This plugin should also include a `SmartAbstractStore` that fixes the
Rails `AbstractStore`. This is the parent class of the `ActiveRecordStore`
which would fix its behaviour in turn. Some unit tests would be good, too ;)
