angular.module('filters', []).
    filter('reverse',function() {
        return function(input) {
            if (input instanceof Array)
                return input.slice().reverse();
            else
                return input;
        };
    });
