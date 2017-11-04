app = angular.module 'BlueGiantApp', ['ngResource', 'ngAnimate', 'angular-websocket']
app.config ['$httpProvider', ($httpProvider)->
  csrfToken = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = csrfToken
]

app.factory 'Market', ['$resource', ($resource)->
  $resource('/markets/:id.json', {
    id: '@id'
  }, {
    'update': { method: 'PUT' }
  })
]

app.filter 'orderHashBy', ()->
  (items, field, reverse)->
    filtered = []
    angular.forEach items, (item)->filtered.push(item)
    filtered.sort (a, b)->(if a[field] > b[field] then 1 else -1)
    filtered.reverse() if reverse
    filtered

app.filter 'elapsedTime', ()->
  intervals = [
    {key: 'year', value: 31536000}
    {key: 'month', value: 2592000}
    {key: 'day', value: 86400}
    {key: 'hour', value: 3600}
    {key: 'minute', value: 60}
    {key: 'second', value: 1}
  ]
  (date, since)->
    seconds = Math.floor(((since||new Date()) - date) / 1000)
    return "< 5 seconds" if seconds <= 5 
    counter = 0
    for intv in intervals
      counter = Math.floor(seconds / intv.value)
      return "#{counter} #{intv.key}s ago" if counter > 0

app.controller 'MainController', ['$scope', ($scope)->
  $scope.init = ()->
    # do nothing
]
