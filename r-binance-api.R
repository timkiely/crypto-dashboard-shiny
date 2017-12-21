


library(httr)
library(tidyverse)

base_url <- "https://api.binance.com"


# ping server -------------------------------------------------------------
test_con <- "/api/v1/ping"
test_connect <- GET(paste0(base_url, test_con))
test_connect$status_code == 200



# server time -------------------------------------------------------------
get_time <- "/api/v1/time"
connect_time <- GET(paste0(base_url, get_time))

connect_time$status_code == 200
return_time <- content(connect_time)
return_time$serverTime # time returned in unix epoch milliseconds
as.POSIXct(return_time$serverTime/1000, origin="1970-01-01")



# current price -----------------------------------------------------------
binance_current_price <- function(){
  url <- paste0("https://api.binance.com/api/v1/ticker/allPrices")
  market_price_raw <- GET(url)
  market_price_raw <- rawToChar(market_price_raw$content)
  market_price <- jsonlite::fromJSON(market_price_raw)
  return(market_price)
  
}

all_prices <- binance_current_price()
all_prices$Time_Stamp <- format(Sys.time(), TZ = "EST")
all_prices %>% filter(grepl("IOTA",symbol))




# 24 hour prices ----------------------------------------------------------
binance_24h_ticker_data<- function(symbol = "ETHBTC"){
  url <- paste0("https://api.binance.com/api/v1/ticker/24hr?symbol=", symbol)
  ticker_price_raw <- GET(url)
  ticker_price_raw <- rawToChar(ticker_price_raw$content)
  ticker_price <- jsonlite::fromJSON(ticker_price_raw)
  ticker_price <- ticker_price %>% map(as.character) %>% bind_rows()
  # ticker_price <- sapply(ticker_price, function(x) as.numeric(as.character(x)))
  
  #ticker_price <- data.frame(t(ticker_price))
  #rownames(ticker_price) <- c(as.character(symbol))
  
  #ticker_price[,16:17] <- lapply(ticker_price[,16:17], function(x) as.POSIXct(x/1000, origin = "1970/01/01"))
  return(ticker_price)
}

binance_24h_ticker_data(symbol = "IOTABTC")


















