app = angular.module 'BlueGiantApp', ['ngResource', 'ngAnimate']
app.factory 'Market', ($resource)->
  $resource('/markets/:id.json', {
    id: '@id'
  })
app.controller 'MainController', ($scope)->
  $scope.init = ()->
    # do nothing
