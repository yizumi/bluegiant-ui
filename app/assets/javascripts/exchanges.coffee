app = angular.module('BlueGiantApp')
app.controller 'ExchangesController', ['$scope','Market', ($scope, Market)->
  $scope.init = (data)->
    $scope.markets= $pageData.markets

  $scope.toggleSubscription = (market)->
    market.subscribed = !market.subscribed
    Market.update {id: market.id}, market, (success)->
      console.info('success')
    , (error)->
      console.error(error)
]
