require './app/controllers/analyzer/analyzelog.rb'

class HomeController < ApplicationController
  def top
    @hash_datas = Analyzelog.analyzelog
  end
end
