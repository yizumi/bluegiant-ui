app = angular.module 'BlueGiantApp', ['ngResource', 'ngAnimate']
app.controller 'MainController', ($scope)->
  $scope.init = ()->
