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
        $('.add-dish-wrapper').slideDown('slow');
    });

    $scope.add = function() {
        $scope.dish.user_id = $('#data').data('user-name');
        $scope.order.dishes.push($scope.dish);
        $scope.$emit('DISH_ADDED', $scope.order);
        initEmpty();
    };

    initEmpty();

}]);

app.controller('OrdersController', ['$scope', '$rootScope', 'Order', function ($scope, $rootScope, Order) {
    $scope.order = {};

    $scope.isActive = function(order) {
        return order.active;
    };

    $scope.isFinalized = function(order) {
        return !order.active;
    }

    var init = function(){
        $scope.orders = Order.query();
    };

    $rootScope.$on('DISH_ADDED', function(event,order) {
        $('.add-dish-wrapper').slideUp('slow');
        $scope.save(order);
    });

    $rootScope.$on('DISH_REMOVED', function(event,order) {
        $scope.save(order);
    });

    $scope.add = function() {
        $scope.order.active = true;
        Order.save($scope.order, function(data){ init(); });
    };

    $scope.show = function(order) {
        $scope.$emit('ORDER_SELECTED', order);
    };

    $scope.removeOrder = function(order) {
        if (confirm('Are you sure you want to remove order ' + order.name + '?'))
            Order.remove({id:order._id}, function(data){ init(); });
    };

    $scope.removeDish = function(order, dish) {
        var index = order.dishes.indexOf(dish);
        if (confirm('Are you sure you want to remove dish ' + dish.description + '?')) {
            order.dishes.splice(index,1);
            $scope.$emit('DISH_REMOVED', order);
        }
    };

    $scope.finalize = function (id) {
        $.ajax({
            url: 'order_finalize',
            data: {id: id}
        }).done(function (data) { init(); }
        ).fail(function(jqXHR, textStatus) { console.log(jqXHR, textStatus) });
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
