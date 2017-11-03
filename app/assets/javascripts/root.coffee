app = angular.module 'BlueGiantApp'
app.controller 'RootController', ['$scope', '$interval', ($scope, $interval)->
  
  $scope.CONNECTING = 'connecting'
  $scope.CONNECTED = 'connected'
  $scope.ERROR = 'error'

  $scope.init = ()->
    $scope.socketStatus = $scope.CONNECTING
    $scope.reports = {}
    $scope.blotterOrderKey = 'market_code'
    $scope.blotterReversed = false
    $interval ()->
      for report in $scope.reports
        report.currentTime = new Date()
    , 1000
    socketInit()

  socketCredentials = ()->
    $scope.config
 
  socketInit = ()->
    # $scope.socket = new WebSocket("ws://104.198.124.78:8080/echo")
    $scope.socket = new WebSocket("ws://localhost:8080/echo")
    $scope.socket.onconnect = socketConnected
    $scope.socket.onmessage = socketOnMessage
  
  socketConnected = (status)->
    $scope.socketStatus = $scope.CONNECTED
    $scope.$apply()

  socketOnMessage = (event)->
    message = JSON.parse(event.data)
    $scope.reports[message.currency_pair] = message
    if message.currency_pair == $scope.currencyPair
      message.lastUpdate = new Date()
      $scope.report = message
      $scope.$apply()

  $scope.keyOf = (data)->
    data.ask_exchange + "--" + data.bid_exchange

  $scope.socketStatusIs = (status)->
    $scope.socketStatus == status

  $scope.currencyPairs = ()->
    Object.keys($scope.reports)

  $scope.changeOrder = (field)->
    $scope.blotterReversed = !$scope.blotterReversed if $scope.blotterOrderKey == field
    $scope.blotterOrderKey = field

  $scope.onCurrencyPairChange = ()->
    $scope.report = $scope.reports[$scope.currencyPair]

  $scope.recent = (spread)->
    bidTS = Date.parse(spread.bid_ts+'Z')
    askTS = Date.parse(spread.ask_ts+'Z')
    new Date() - Math.max(bidTS, askTS) < 2000
]
