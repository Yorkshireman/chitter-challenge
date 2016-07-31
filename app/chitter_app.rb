require 'sinatra/base'
require_relative 'datamapper_setup.rb'
require 'rack-flash'

class Chitter < Sinatra::Base
  enable :sessions unless test?
  set :session_secret, 'super secret'
  use Rack::Flash, sweep: true

  get '/' do
    @peeps = Peep.all.reverse
    erb :'peeps/index'
  end

  get '/peeps/new' do
    erb :'peeps/new'
  end

  post '/peeps/' do
    current_user.peeps.create(content: params['content'])
    redirect to('/')
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users/' do
    user = User.new(email: params['email'], password: params['password'])
    if user.save
      session[:user_id] = user.id
      redirect to('/')
    else
      erb :'users/new'
      flash[:notice] = "#{user.errors[:email]}"
    end
  end

  private

  helpers do
    def formatted_time_stamp(time_stamp)
      time_stamp.ctime
    end

    def current_user
      User.get(session[:user_id])
    end
  end
end