var app = angular.module('app', ['flash', '$strap.directives', 'ngResource']);

// app.config( ['$routeProvider', function ($routeProvider) {
//     $routeProvider.when('/', { templateUrl: '/assets/patents/index.html', controller: 'OrdersController' });
// }]);
app.controller('DishesController', ['$scope', '$rootScope', function ($scope, $rootScope) {
    var initEmpty = function() {
        $scope.order = {};
        $scope.dish  = {};
    };

    $rootScope.$on('ORDER_SELECTED', function(event,message) {
        $scope.order = message;
    });

    $scope.add = function() {
        $scope.dish.user_id = $('#data').data('user-name');
        $scope.order.dishes.push($scope.dish);
        $scope.$emit('DISH_ADDED', $scope.order);
        initEmpty();
    };

    $scope.remove = function(dish) {
        var index = $scope.dishes.indexOf(dish);
        $scope.dishes.splice(index,1);
    };

    initEmpty();

}]);

app.controller('OrdersController', ['$scope', '$rootScope', 'Order', function ($scope, $rootScope, Order) {
    $scope.order = {};

    var init = function(){
        $scope.orders = Order.query();
    };

    $rootScope.$on('DISH_ADDED', function(event,order) {
        $scope.save(order)
    });

    $rootScope.$on('DISH_REMOVED', function(event,order) {
        $scope.save(order)
    });

    $scope.add = function() {
        Order.save($scope.order, function(data){ init(); });
    };

    $scope.show = function(order) {
        $scope.$emit('ORDER_SELECTED', order);
    };

    $scope.remove = function(id) {
        Order.remove({id:id}, function(data){ init(); });
    };

    $scope.removeDish = function(order, dish) {
        var index = order.dishes.indexOf(dish);
        order.dishes.splice(index,1);
        $scope.$emit('DISH_REMOVED', order);
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
