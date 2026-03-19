# Generic HTTP Web Service Server in Ruby (GHoWSt)

![Logo](http://www.weburg.com/ghowst/images/ghowstlogo.png)

## An example server providing the Web service and an HTML-only static client

> [!NOTE]
> This is a work in progress to bring a GHoWSt Ruby server library up to parity with the Java version. Refer to the Java version until this note is removed.

Simple MVC architecture where controllers are defined in app.rb, views are in views/, and the model is whatever is needed, kept in app/.

Routing is provided by Sinatra. Path parameters are not used. Query string and URI parsing are done as needed.

### General setup

We're going to use the Puma Rack server and rely on Sinatra to be the static HTML server.

Install Ruby 3.

### IDE (RubyMine) setup

Add <project_root>/lib to IDE's Load Path (Settings -> Project Structure -> Load Path)

Mark directories as you wish, e.g. Sources Root, Templates, Test Sources, etc. (right click desired folder, then select Mark Directory As)

Make sure the required bundler gems are installed.

### Running the application

The application will run with the Puma Rack server on port 8081.

If using the CLI, ensure you are in the project directory. Run:

`bundle exec puma -p 8081`

If using an IDE, create a Rack run configuration with Port set to 8081 and the
Rack config file set to <project root>/config.ru. Then you can run or debug the
application. All the gems needed for remote debugging to work are already in the
Gemfile.

Now test the application by going to http://localhost:8081 and make sure everything works.

### Running the tests

To run unit tests only:

`rake`

To run unit and integration tests:

First, ensure the Puma Rack server is running, then:

`rake test verify`