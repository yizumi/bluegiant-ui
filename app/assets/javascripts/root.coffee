app = angular.module 'BlueGiantApp'
app.controller 'RootController', ($scope)->
  
  $scope.CONNECTING = 'connecting'
  $scope.CONNECTED = 'connected'
  $scope.ERROR = 'error'

  $scope.init = (apiKey, apiSecret)->
    $scope.socketStatus = $scope.CONNECTING
    $scope.config = { apiKey: apiKey, apiSecret: apiSecret }
    $scope.blotter = {}
    socketInit()

  socket = null

  socketOptions = ()->
    {
      hostname: 'sc-02.coinigy.com'
      port: 443
      secure: true
    }

  socketCredentials = ()->
    $scope.config
  
  socketInit = ()->
    socket = socketCluster.connect(socketOptions())
    socket.on 'connect', socketConnected
    socket.on 'error', (err)->
      console.error(err)

  socketConnected = (status)->
    console.log('Connected')
    socket.emit 'auth', socketCredentials(), socketAuthenticated

  socketAuthenticated = (err, token)->
    if !err && token
      $scope.socketStatus = $scope.CONNECTED
      $scope.$apply()
      for market in $pageData.markets
        socketSubscribe(market.subscription_code)
    else
      $scope.socketStatus = $scope.ERROR
      $scope.socketError = 'Authentication failed'

  socketSubscribe = (code)->
    ch = socket.subscribe(code)
    ch.watch (data)->
      summary = buildMarketSummary(data)
      return if summary is undefined
      $scope.blotter[code] = summary
      $scope.$apply()
    console.info("Subscribed to #{code}")
  
  buildMarketSummary = (orders)->
    first = orders[0]
    return if first.exchange is undefined or first.label is undefined
    summary = buildEmptySummary(first)
    for order in orders
      continue if order is null
      if order.ordertype is 'Buy' # Ask
        summary.highest_ask_price = Math.max(summary.highest_ask_price, order.price)
        summary.lowest_ask_price = Math.min(summary.lowest_ask_price, order.price)
        summary.highest_ask_quantity = order.quantity if summary.highest_ask_price is order.price
        summary.lowest_ask_quantity = order.quantity if summary.lowest_ask_price is order.price
      if order.ordertype is 'Sell' # Bid
        summary.highest_bid_price = Math.max(summary.highest_bid_price, order.price)
        summary.lowest_bid_price = Math.min(summary.lowest_bid_price, order.price)
        summary.highest_bid_quantity = order.quantity if summary.highest_bid_price is order.price
        summary.lowest_bid_quantity = order.quantity if summary.lowest_bid_price is order.price
    summary

  buildEmptySummary = (first)->
    {
      exchange_code: first.exchange
      market_code: first.label
      highest_ask_price: Number.MIN_VALUE
      lowest_ask_price: Number.MAX_VALUE
      highest_ask_quantity: 0
      lowest_ask_quantity: 0
      highest_bid_price: Number.MIN_VALUE
      lowest_bid_price: Number.MAX_VALUE
      highest_bid_quantity: 0
      lowest_bid_quantity: 0
      timestamp: first.timestamp
    }

  $scope.socketStatusIs = (status)->
    $scope.socketStatus == status
