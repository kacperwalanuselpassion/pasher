var app = angular.module('app', ['flash', '$strap.directives', 'ngResource']);

// app.config( ['$routeProvider', function ($routeProvider) {
//     $routeProvider.when('/', { templateUrl: '/assets/patents/index.html', controller: 'OrdersController' });
// }]);
app.controller('DishesController', ['$scope', '$rootScope', function ($scope, $rootScope) {
    $scope.order = {};
    $scope.dish  = {};

    $rootScope.$on('ORDER_SELECTED', function(event,message) {
        console.log(message);
        $scope.order = message;
    });

    $scope.add = function() {
        $scope.order.dishes.push($scope.dish);
    };

    $scope.remove = function(dish) {
        var index = $scope.dishes.indexOf(dish);
        $scope.dishes.splice(index,1);
    };

}]);

app.controller('OrdersController', ['$scope', 'Order', function ($scope, Order) {
    $scope.order  = {};

    var init = function(){
        $scope.orders = Order.query();
    };

    $scope.add = function() {
        Order.save($scope.order, function(data){ init(); });
    };

    $scope.show = function(order) {
        $scope.$emit('ORDER_SELECTED', order);
    };

    $scope.remove = function(id) {
        Order.remove({id:id}, function(data){ init(); });
    };

    $scope.save = function(order) {
        Order.update({id:order._id}, {order: order}, function(data){ init(); });
    };


    init();

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
