hostname = if document.location.hostname is 'localhost' then 'localhost' else '104.198.124.78'

app = angular.module 'BlueGiantApp'
app.service 'MarketData', ['$websocket', ($websocket)->
  ws = $websocket("ws://#{hostname}:8080/echo")
  blotters = {}
  currencyPairs = []

  ws.onMessage (event)->
    message = JSON.parse(event.data)
    updateCurrencyPairs(message)
    updateMarketData(message)

  updateCurrencyPairs = (message)->
    index = currencyPairs.findIndex (v)->message.currency_pair == v
    currencyPairs.push(message.currency_pair) if index < 0

  updateMarketData = (message)->
    message.data.forEach (d)->
      d.id = "#{message.currency_pair}--#{d.bid_exchange}--#{d.ask_exchange}"
      consumer.onMarketData(d) if consumer.onMarketData
    blotters[message.currency_pair] = message.data

  consumer = {
    blotters: blotters
    currencyPairs: currencyPairs
  }
  
  consumer
]
app.controller 'RootController', ['$scope', '$timeout', 'MarketData', '$http', ($scope, $timeout, MarketData, $http)->
  $scope.MarketData = MarketData 
  $scope.CONNECTING = 'connecting'
  $scope.CONNECTED = 'connected'
  $scope.ERROR = 'error'

  exchangeUrls = (()->
    url = {}
    $pageData.markets.forEach (m)->
      url[m.exchange.code] = m.exchange.url
    url
  )()

  $scope.init = ()->
    $scope.socketStatus = $scope.CONNECTING
    $scope.blotterOrderKey = 'spread_bp'
    $scope.blotterReversed = true
    $scope.selectedPairId = null
    $scope.lastPair = {}
    $scope.bids = []
    $scope.asks = []

  MarketData.onMarketData = (pair)->
    return unless pair.id == $scope.selectedPairId
    return if $scope.lastPair.spread_bp == pair.spread_bp
    $scope.lastPair = pair
    refreshOrders()

  $scope.socketStatusIs = (status)->
    $scope.socketStatus == status

  $scope.changeOrder = (field)->
    $scope.blotterReversed = !$scope.blotterReversed if $scope.blotterOrderKey == field
    $scope.blotterOrderKey = field

  $scope.changeCurrencyPair = (v)->
    $scope.currencyPair = v

  $scope.recent = (spread)->
    bidTS = Date.parse(spread.bid_ts+'Z')
    askTS = Date.parse(spread.ask_ts+'Z')
    new Date() - Math.max(bidTS, askTS) < 10000

  $scope.exchangeUrl = (code)->
    exchangeUrls[code]

  $scope.selectPair = (pairId)->
    $scope.bids = []
    $scope.asks = []
    $scope.selectedPairId = pairId
    refreshOrders()

  refreshOrders = ()->
    match = $scope.selectedPairId.match(/(\w+)\/(\w+)--(\w+)--(\w+)/)
    return unless match
    bid = match[3]
    ask = match[4]
    ccy1 = match[1]
    ccy2 = match[2]
    $timeout ()->
      $http.get("http://#{hostname}:8080/exchanges/#{bid}/#{ccy1}-#{ccy2}/orders").then (res)->
        $scope.bids = res.data.filter (p)->p.ordertype=='Buy'
      $http.get("http://#{hostname}:8080/exchanges/#{ask}/#{ccy1}-#{ccy2}/orders").then (res)->
        $scope.asks = res.data.filter (p)->p.ordertype=='Sell'
    , 500
]
