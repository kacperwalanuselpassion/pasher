var app = angular.module('app', ['flash', '$strap.directives', 'ngResource']);

// app.config( ['$routeProvider', function ($routeProvider) {
//     $routeProvider.when('/', { templateUrl: '/assets/patents/index.html', controller: 'OrdersController' });
// }]);


app.controller('OrdersController', ['$scope', 'Order', function ($scope, Order) {
    $scope.orders = Order.query();
    $scope.order  = {};

    $scope.add = function() {
        $scope.order.ordered_at = new Date();

        Order.save($scope.order,
                   function(data){
                       $scope.orders = Order.query();
                                 });
    };

    $scope.remove = function(id) {
        Order.remove({id:id},
                   function(data){
                       $scope.orders = Order.query();
                                 });
    };

}]);


app.factory('Order', ['$resource', function($resource) {
    var service = $resource(
        '/orders/:id',
        {id:'@id'},
        {
            query:   {method:'GET',  params:{}, isArray:true},
            update:  {method:'PUT' }
        }
    );
    return service;
}]);
