require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"


exrt_key = ENV.fetch("EXCHANGE_RATE_KEY")
exrt_list_resp = JSON.parse(HTTP.get("https://api.exchangerate.host/list?access_key=#{exrt_key}"))


get("/") do
  @exrt_list = exrt_list_resp.fetch("currencies").keys
  erb(:home)
end


get("/:from") do
  @from = params.fetch("from").upcase
  @exrt_list = exrt_list_resp.fetch("currencies").keys
  erb(:convert_to)
end


get("/:from/:to") do
  @from = params.fetch("from").upcase
  @to = params.fetch("to").upcase

  exrt_conv_resp = JSON.parse(HTTP.get("https://api.exchangerate.host/convert?from=#{@from}&to=#{@to}&amount=1&access_key=#{exrt_key}"))
  
  @rate = exrt_conv_resp.fetch("result")

  erb(:convert_rate)
end
