require './app/controllers/analyzer/analyzelog.rb'

class HomeController < ApplicationController
  def top
    @hash_datum = Analyzelog.analyzelog
    puts @hash_datum.inspect
  end
end
