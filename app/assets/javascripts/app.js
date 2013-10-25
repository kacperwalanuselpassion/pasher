CONFIG = $('#pasher-config').data('config')
CHAT_POLLING_INTERVAL = 2000;
ORDERS_POLLING_INTERVAL = 5000;


var app = angular.module('app', ['flash', '$strap.directives', 'ngResource']);

// app.config( ['$routeProvider', function ($routeProvider) {
//     $routeProvider.when('/', { templateUrl: '/assets/patents/index.html', controller: 'OrdersController' });
// }]);

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

app.factory('Dish', ['$resource', function($resource) {
    var service = $resource(
        '/dishes/:id',
        {id:'@id'},
        {
            query:   {method:'GET',  params:{}, isArray:true},
            update:  {method:'PUT' }
        }
    );
    return service;
}]);

app.factory('ChatMessageDAO', ['$resource', function ($resource) {
    var service = $resource(
        '/chat_messages/:id',
        {},
        {
            index: { method: 'GET', isArray: true },
            create: { method: 'POST' },
            destroy: { method: 'DELETE' }
        }
    );
    return service;
}]);

app.controller('DishesController', ['$scope', '$rootScope', 'Dish', function ($scope, $rootScope, Dish) {
    var initEmpty = function() {
        $scope.order = {};
        $scope.dish  = {};
    };

    $rootScope.$on('ORDER_SELECTED', function(event,message) {
        $scope.order = message;
        $('.add-dish-wrapper').slideDown('slow');
    });

    $scope.add = function() {
        $scope.dish.order_uid = $scope.order._id
        Dish.save($scope.dish, function(data){ $scope.$emit('DISH_ADDED'); });
        initEmpty();
    };

    $rootScope.$on('REMOVING_DISH', function(event, dish) {
        $('.add-dish-wrapper').slideUp('slow');
        Dish.remove({id: dish._id}, function(data){ $scope.$emit('DISH_REMOVED'); });
    });

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

    var initializeActiveAndFinalized = function() {
        for (order in $scope.orders) {
            if ($scope.orders[order].active)
                $scope.anyActiveOrders = true;
            else
                $scope.anyFinalizedOrders = true;
        }
    };

    var init = function(){
        $scope.anyActiveOrders = false;
        $scope.anyFinalizedOrders = false;
        $scope.orders = Order.query(initializeActiveAndFinalized);
    };

    ($scope.refreshOrders = function() {
        init();
        setTimeout($scope.refreshOrders, ORDERS_POLLING_INTERVAL);
    })();

    $rootScope.$on('DISH_ADDED', function(event,order) {
        $('.add-dish-wrapper').slideUp('slow');
        init();
    });

    $rootScope.$on('DISH_REMOVED', function(event) {
        init();
    });

    $scope.add = function() {
        $scope.order.active = true;
        Order.save($scope.order, function(data){ init(); });
        $scope.order = {};
    };

    $scope.show = function(order) {
        $('.add-dish-wrapper').slideDown('slow');
        $scope.$emit('ORDER_SELECTED', order);
    };

    $scope.removeOrder = function(order) {
        if (confirm('Are you sure you want to remove order ' + order.name + '?'))
            Order.remove({id:order._id}, function(data){ init(); });
    };

    $scope.removeDish = function(dish) {
        if (confirm('Are you sure you want to remove dish ' + dish.description + '?')) {
            $scope.$emit('REMOVING_DISH', dish);
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

app.controller('ChatController', ['$scope', '$rootScope', 'ChatMessageDAO', function ($scope, $rootScope, ChatMessageDAO) {
    var init = function() {
        $scope.chatMessageText = '';
        chatPolling();
    };

    var chatPolling = function() {
        $scope.chatMessages = ChatMessageDAO.index();
        setTimeout(chatPolling, CHAT_POLLING_INTERVAL);
    };

    $scope.sendMessage = function() {
        ChatMessageDAO.create({text: $scope.chatMessageText}, function(data) {
            init();
        })
    };

    if(CONFIG.chat.on == 1) { init(); }
}]);
