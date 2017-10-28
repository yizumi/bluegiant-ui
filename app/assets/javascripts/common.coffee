app = angular.module 'BlueGiantApp', ['ngResource', 'ngAnimate']
app.config ($httpProvider)->
  csrfToken = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = csrfToken

app.factory 'Market', ($resource)->
  $resource('/markets/:id.json', {
    id: '@id'
  }, {
    'update': { method: 'PUT' }
  })

app.controller 'MainController', ($scope)->
  $scope.init = ()->
    # do nothing
