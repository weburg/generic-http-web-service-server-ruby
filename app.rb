$LOAD_PATH << File.expand_path('lib', __dir__)

require 'sinatra'
require 'json'
require 'my_function'
require 'domain/omnibus'

get '/' do
  @date = Time.now.utc
  @request_uri = request.path_info
  @my_function = :my_function
  erb :home
end

get "/generichttpws/?*" do
  @request_uri = request.path_info
  if params["splat"].first.split("/").last == "engines"
    erb :"generichttpws/engines"
  elsif params["splat"].first.split("/").last == "omnibus"
    omnibus = Omnibus.new
    omnibus.birthtime = Time.now
    omnibus.sendtime = Time.now.utc
    omnibus.toppings = ["Cheese", "Pepperoni", "Sausage"]
    omnibus.sides = ["Fries", "Onion Rings"]
    omnibus.onFire = false
    omnibus.document = nil
    omnibus.pairing = {
      "Steak" => "Cabernet Sauvignon",
      "Fish" => "Chardonnay",
    }

    JSON.generate(omnibus.instance_variables.to_h { |ivar| [ivar.to_s.delete_prefix("@"), omnibus.instance_variable_get(ivar)] })
  else
    erb :"generichttpws/home"
  end
end