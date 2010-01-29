Add the `smart_cookie_store.rb` file to your `lib/` folder of your Rails app.
Then configure the app to use the new store:

    config.action_controller.session_store = :smart_cookie_store
