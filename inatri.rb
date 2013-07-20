require 'sinatra/base'
require 'mustache/sinatra'

$: << File.join(File.dirname(__FILE__), 'lib')

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

  get '/about' do
    mustache :about
  end

  get '/search' do
    @query = params[:q]
    @type  = params[:type]
    mustache :search
  end

  get '/overviewer' do
    @query = params[:q]
    @type  = params[:type]
    mustache :overviewer
  end
end
