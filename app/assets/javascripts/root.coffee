app = angular.module 'BlueGiantApp'
app.service 'MarketData', ['$websocket', ($websocket)->
  ws = $websocket('ws://104.198.124.78:8080/echo')
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
    blotters[message.currency_pair] = message.data

  {
    blotters: blotters
    currencyPairs: currencyPairs
  }
]
app.controller 'RootController', ['$scope', '$interval', 'MarketData', ($scope, $interval, MarketData)->
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
]
