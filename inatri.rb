require 'sinatra/base'
require 'mustache/sinatra'

class Inatri < Sinatra::Application
  register Mustache::Sinatra
  require './views/layout'

  set :mustache, {
    :views     => './views',
    :templates => './templates',
  }

  get '/' do
    mustache :index
  end

  get '/search' do
    @query = 'example'

    mustache :search
  end

  get '/overviewer' do
    @query = 'hello world'

    mustache :overviewer
  end
end
