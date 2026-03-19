require "sinatra"

def my_function(name)
  "Your function knows you as " + name
end

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
  else
    erb :"generichttpws/home"
  end
end