CONFIG = $('#pasher-config').data('config');

var app = angular.module('app', ['flash', 'ui.bootstrap', 'ngResource', 'filters', 'timer', 'ui.select2']);

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

app.factory('BitcoinWallet', ['$resource', function ($resource) {
    var service = $resource(
        '/bitcoin_wallets/:id',
        {id: '@id'},
        {
            index: { method: 'GET' }
        }
    );
    return service;
}]);

app.service('ErrorHandler', ['$resource', function($resource) {
    this.displayAlert = function(responseText) {
        alert(responseText.error.message)
    }
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
        Dish.save($scope.dish,
            function(data){
                $scope.$emit('DISH_ADDED');
            });
        initEmpty();
    };

    $scope.edit = function() {
        Dish.update({id: $scope.dish._id},{dish: $scope.dish},
            function(data){
                $scope.$emit('DISH_UPDATED');
            });
        initEmpty();
    };

    $rootScope.$on('REMOVING_DISH', function(event, dish) {
        $('.add-dish-wrapper').slideUp('slow');
        Dish.remove({id: dish._id},
            function(data){
                $scope.$emit('DISH_REMOVED');
            });
    });

    $rootScope.$on('EDITING_DISH', function(event, dish) {
        $scope.dish = dish;
        $('.edit-dish-wrapper').slideDown('slow');
    });

    initEmpty();
}]);

app.controller('OrdersController', ['$scope', '$rootScope', '$location', 'Order', 'ErrorHandler', 'BitcoinWallet',
    function ($scope, $rootScope, $location, Order, ErrorHandler, BitcoinWallet) {
        $scope.bitcoinSelect2Options = {
            simple_tags: true,
            maximumSelectionSize: 1,
            maximumInputLength: 34,
            tags: [],
            ajax: {
                url: 'http://localhost:3000/bitcoin_wallets.json',
                dataType: 'json',
                results: function(data, page) {
                    return {
                        results: $.map(data.bitcoin_wallets,
                            function(value, index) { return {id: value, text: value}; })
                    }
                }
            },
            createSearchChoice: function(term) {
                return { id: term, text: term };
            }
        };

        $scope.timerRunning = true;
        $scope.order = {};
        $scope.currentUser = $('#data').data('user-uid');

        $scope.isActive = function(order) {
            return order.active;
        };

        $scope.canJoinToDish = function(dish) {
            return (dish.joinable && dish.participants_limit > dish.users_uids.length - 1);
        }

        $scope.belongsToCurrentUser = function(order) {
            return order.founder_uid == $scope.currentUser;
        }

        $scope.belongsToCurrentUser = function(order) {
            return order.founder_uid == $scope.currentUser;
        }

        $scope.dishBelongsToCurrentUser = function(dish) {
            return dish.users_uids.contains($scope.currentUser);
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

        var handleRoutes = function(path) {
            var pathMembers = path.replace(/^\/+|\/+$/g, '').split('/');
            if (pathMembers[0] == 'edit' && pathMembers.length > 1) {
                Order.get({id: pathMembers[1]}, function(order) {
                    angular.copy(order, $scope.order);
                    $('.edit-order-wrapper').show();
                });
            } else if (pathMembers[0] == 'add_bitcoin_address' && pathMembers.length > 1) {
                Order.get({id: pathMembers[1]}, function(order) {
                    angular.copy(order, $scope.order);
                    $('.add-bitcoin-address-wrapper').show();
                });
            };
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

            if (!$scope.order.ordered_at)
                $scope.order.ordered_at = new Date();

            Order.save($scope.order,
                function(data){
                    init();
                });
            $scope.order = {};
        };

        $scope.edit = function() {
            Order.update({id: $scope.order._id}, {order: $scope.order},
                function(data){
                    init();
                });
            $scope.order = {};
            $('.edit-order-wrapper').slideUp('slow')
        };

        $scope.editOrder = function(order) {
            $scope.order = order;
            $scope.order.bitcoin_wallet_remember = false;

            $('.edit-order-wrapper').slideDown('slow')
        }

        $scope.show = function(order) {
            $('.add-dish-wrapper').slideDown('slow');
            $scope.$emit('ORDER_SELECTED', order);
        };

        $scope.removeOrder = function(order) {
            if (confirm('Are you sure you want to remove order ' + order.name + '?'))
                Order.remove({id:order._id},
                    function(data){
                        init();
                    });
        };

        $scope.removeDish = function(dish) {
            if (confirm('Are you sure you want to remove dish ' + dish.description + '?')) {
                $scope.$emit('REMOVING_DISH', dish);
            }
        };

        $scope.editDish = function(dish) {
            $scope.$emit('EDITING_DISH', dish);
        };

        $scope.joinToDish = function(dish) {
            $.ajax({
                url: 'dishes/' + dish._id + '/join',
                method: 'put'
            }).done(function (data) {
                    init();
                }
            ).fail(function(jqXHR){
                    var responseText = jQuery.parseJSON((jqXHR.responseText))
                    ErrorHandler.displayAlert(responseText)
                });
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
        handleRoutes($location.path());
}]);

app.controller('ChatController', ['$scope', '$rootScope', 'ChatMessageDAO', function ($scope, $rootScope, ChatMessageDAO) {
    var init = function() {
        $scope.chatMessageText = '';
        $scope.chatShown = localStorage['chatShown'];
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
        localStorage['chatShown'] = $scope.chatShown = !$scope.chatShown;
    };

    if(CONFIG.chat.on) { init(); }
}]);
