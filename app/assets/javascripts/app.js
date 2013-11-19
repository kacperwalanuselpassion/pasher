CONFIG = $('#pasher-config').data('config');

var app = angular.module('app', ['flash', '$strap.directives', 'ngResource', 'filters']);

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

    $rootScope.$on('ORDER_SELECTED', function(event, order) {
        $scope.order = order;
    });

    $scope.add = function() {
        $scope.dish.order_uid = $scope.order._id
        Dish.save($scope.dish, function(data){ $scope.$emit('DISH_ADDED'); });
        initEmpty();
    };

    $scope.edit = function() {
        Dish.update({id: $scope.dish._id},{dish: $scope.dish}, function(data){ $scope.$emit('DISH_UPDATED'); });
        initEmpty();
    };

    $rootScope.$on('REMOVING_DISH', function(event, dish) {
        $('.add-dish-wrapper').slideUp('slow');
        Dish.remove({id: dish._id}, function(data){ $scope.$emit('DISH_REMOVED'); });
    });

    $rootScope.$on('EDITING_DISH', function(event, dish) {
        $scope.dish = dish;
        $('.edit-dish-wrapper').slideDown('slow');
    });

    initEmpty();
}]);

app.controller('OrdersController', ['$scope', '$rootScope', 'Order', function ($scope, $rootScope, Order) {
    $scope.order = {};
    $scope.currentUser = $('#data').data('user-uid');

    $scope.isActive = function(order) {
        return order.active;
    };

    $scope.belongsToCurrentUser = function(order) {
        return order.founder_uid == $scope.currentUser;
    }

    $scope.dishBelongsToCurrentUser = function(dish) {
        return dish.user_uid == $scope.currentUser;
    }

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
        Order.query(
            {},
            function(data) {
                $scope.orders = data;
                initializeActiveAndFinalized();
            });
    };

    ($scope.refreshOrders = function() {
        init();
        setTimeout($scope.refreshOrders, CONFIG.orders.polling_interval);
    })();

    $rootScope.$on('DISH_ADDED', function(event,order) {
        $('.add-dish-wrapper').slideUp('slow');
        init();
    });

    $rootScope.$on('DISH_UPDATED', function(event,order) {
        $('.edit-dish-wrapper').slideUp('slow');
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

    $scope.edit = function() {
        Order.update({id: $scope.order._id}, {order: $scope.order}, function(data){ init(); });
        $scope.order = {};
        $('.edit-order-wrapper').slideUp('slow')
    };

    $scope.editOrder = function(order) {
        $scope.order = order;
        $('.edit-order-wrapper').slideDown('slow')
    }

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

    $scope.editDish = function(dish) {
        $scope.$emit('EDITING_DISH', dish);
    };

    $scope.finalize = function(id) {
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
        $scope.chatShown = true;
        chatPolling();
    };

    var scrollChat = function() {
        var chatMessagesDiv = document.getElementById('chat-message-list');
        chatMessagesDiv.scrollTop = chatMessagesDiv.scrollHeight;
    };

    var fillOmitHeaderFields = function() {
        var chatMessagesCount = $scope.chatMessages.length - 1;
        $scope.chatMessages[chatMessagesCount].omitHeader = false;
        for (var message = 1; message <= chatMessagesCount; ++message) {
            $scope.chatMessages[message].omitHeader =
                ($scope.chatMessages[message].sender_uid == $scope.chatMessages[message - 1].sender_uid);
        }
    };

    var chatPolling = function() {
        ChatMessageDAO.index({}, function(data) {
            $scope.chatMessages = data;
            fillOmitHeaderFields();
//            scrollChat();
        });
        setTimeout(chatPolling, CONFIG.chat.polling_interval);
    };

    $scope.sendMessage = function() {
        ChatMessageDAO.create({text: $scope.chatMessageText}, function(data) {
//            scrollChat();
        });
        $scope.chatMessageText = '';
    };

    $scope.toggleChat = function() {
        $scope.chatShown = !$scope.chatShown;
    };

    if(CONFIG.chat.on) { init(); }
}]);
