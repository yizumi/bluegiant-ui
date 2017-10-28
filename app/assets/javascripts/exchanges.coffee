app = angular.module('BlueGiantApp')
app.controller 'ExchangesController', ($scope, Market)->
  $scope.init = (data)->
    $scope.markets= $pageData.markets

  $scope.toggleSubscription = (market)->
    if market.subscription
      disableSubscription(market)
    else
      enableSubscription(market)

  enableSubscription = (market)->
    Market.get market, (m)->
      console.info(m)
