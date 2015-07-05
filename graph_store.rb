require 'sinatra'
require 'json'

before do
    content_type 'application/json'
end

#TODO: other message when request is not found ex: post delete
not_found do
  {error: "Graph not found!"}.to_json
end

error 400 do
  {error: "Invalid request!"}.to_json
end

error 409 do
  {error: "Graph with provided name already exists!"}.to_json
end

error 500...600 do
  {error: "Internal server error!"}.to_json
end

#TODO:documentation
get '/' do
  "documentation"
end

get '/list' do
  graph_names = Dir["graphs/*"].map { |file|
    File.basename(file)
  }
  {graphs: graph_names}.to_json
end

post '/new' do
  graph_name = params[:name]

  halt 400 if graph_name == nil

  graph_name = "graphs/#{graph_name}"
  if File.exist?(graph_name)
    halt 409
  else
    File.write(graph_name, params.to_json)
  end
end

put '/rename' do
  old_name = params[:old_name]
  new_name = params[:new_name]

  halt 400 if old_name == nil || new_name == nil

  old_name = "graphs/#{old_name}"
  new_name = "graphs/#{new_name}"

  if File.exist?(old_name)
    File.rename(old_name, new_name)
  else
    halt 404
  end
end

delete '/delete' do
  graph_name = params[:name]

  halt 400 if graph_name == nil

  graph_name = "graphs/#{graph_name}"

  if File.exist?(graph_name)
    File.delete(graph_name)
  else
    halt 404
  end
end

get '/search/:query' do
  query = params[:query]
  halt 400 if query == nil

  graphs_names = Dir["graphs/*#{query}*"].map { |file|
    File.basename(file)
  }

  {graphs: graphs_names}.to_json
end

#TODO: add edge
post '/add/edge' do
end

#TODO: add vertex
post '/add/vertex' do
end

#TODO: delete edge
delete '/delete/edge' do
end

#TODO: delete vertex
delete '/delete/vertex' do
end

#TODO: update edge
put '/update/edge' do
end

#TODO: update vertex
put '/update/vertex' do
end

#TODO: serch vertex
get '/search/vertex/:name' do
end

#TODO: serch vertex
get '/search/vertex/:u/:v' do
end

#TODO: and more alghorithms
