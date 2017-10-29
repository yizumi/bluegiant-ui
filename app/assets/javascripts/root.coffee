app = angular.module 'BlueGiantApp'
app.controller 'RootController', ['$scope', '$interval', ($scope, $interval)->
  
  $scope.CONNECTING = 'connecting'
  $scope.CONNECTED = 'connected'
  $scope.ERROR = 'error'

  $scope.init = (apiKey, apiSecret)->
    $scope.socket = null
    $scope.socketStatus = $scope.CONNECTING
    $scope.config = { apiKey: apiKey, apiSecret: apiSecret }
    $scope.blotter = {}
    $scope.blotterOrderKey = 'market_code'
    $scope.blotterReversed = false
    $interval updateBlotterCurrentTime, 5000
    socketInit()

  socketOptions = ()->
    {
      hostname: 'sc-02.coinigy.com'
      port: 443
      secure: true
    }

  socketCredentials = ()->
    $scope.config
 
  socketInit = ()->
    $scope.socket = socketCluster.connect(socketOptions())
    $scope.socket.on 'connect', socketConnected
    $scope.socket.on 'error', (err)->
      console.error(err)

  socketConnected = (status)->
    console.log('Connected')
    $scope.socket.emit 'auth', socketCredentials(), socketAuthenticated

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
    ch = $scope.socket.subscribe(code)
    ch.watch (data)->
      summary = buildMarketSummary(data)
      return if summary is null
      $scope.blotter[code] = summary
      $scope.$apply()
    console.info("Subscribed to #{code}")
  
  buildMarketSummary = (orders)->
    first = orders[0]
    return null if first.exchange is undefined or first.label is undefined
    summary = buildEmptySummary(first)
    orders.forEach (o)->refreshSummary(summary, o)
    summary

  refreshSummary = (s, o)->
    return null if o is null
    if o.ordertype is 'Buy' # Ask
      s.highest_ask_price = Math.max(s.highest_ask_price, o.price)
      s.lowest_ask_price = Math.min(s.lowest_ask_price, o.price)
      s.highest_ask_quantity = o.quantity if s.highest_ask_price is o.price
      s.lowest_ask_quantity = o.quantity if s.lowest_ask_price is o.price
    if o.ordertype is 'Sell' # Bid
      s.highest_bid_price = Math.max(s.highest_bid_price, o.price)
      s.lowest_bid_price = Math.min(s.lowest_bid_price, o.price)
      s.highest_bid_quantity = o.quantity if s.highest_bid_price is o.price
      s.lowest_bid_quantity = o.quantity if s.lowest_bid_price is o.price
    s.timestamp = new Date(Math.max(new Date(o.timestamp), s.timestamp))

  buildEmptySummary = (first)->
    {
      id: "#{first.exchange}--#{first.label}"
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
      currentTime: new Date()
      timestamp: new Date("#{first.timestamp} GMT")
    }

  $scope.socketStatusIs = (status)->
    $scope.socketStatus == status

  updateBlotterCurrentTime = ()->
    date = new Date()
    $scope.blotter.forEachKeyValue (k, v)->v.currentTime = date

  $scope.changeOrder = (field)->
    $scope.blotterReversed = !$scope.blotterReversed if $scope.blotterOrderKey == field
    $scope.blotterOrderKey = field
]
