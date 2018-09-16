angular.module("myApp")
//using for date picker
.directive('datepicker', function () {
    return {
        require: 'ngModel',
        link: function (scope, el, attr, ngModel) {
            $(el).datepicker(

                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd-mm-yy',
                    onSelect: function (dateText) {
                        scope.$apply(function () {
                            ngModel.$setViewValue(dateText);
                        });
                    }
                });
        }
    };
})
.directive('validNumber', function () {
    return {
        require: '?ngModel',
        link: function (scope, element, attrs, ngModelCtrl) {
            if (!ngModelCtrl) {
                return;
            }

            ngModelCtrl.$parsers.push(function (val) {
                if (angular.isUndefined(val)) {
                    var val = '';
                }

                var clean = val.replace(/[^-0-9\.]/g, '');
                var negativeCheck = clean.split('-');
                var decimalCheck = clean.split('.');
                if (!angular.isUndefined(negativeCheck[1])) {
                    negativeCheck[1] = negativeCheck[1].slice(0, negativeCheck[1].length);
                    clean = negativeCheck[0] + '-' + negativeCheck[1];
                    if (negativeCheck[0].length > 0) {
                        clean = negativeCheck[0];
                    }

                }

                if (!angular.isUndefined(decimalCheck[1])) {
                    decimalCheck[1] = decimalCheck[1].slice(0, 2);
                    clean = decimalCheck[0] + '.' + decimalCheck[1];
                }

                if (val !== clean) {
                    ngModelCtrl.$setViewValue(clean);
                    ngModelCtrl.$render();
                }
                return clean;
            });

            element.bind('keypress', function (event) {
                if (event.keyCode === 32) {
                    event.preventDefault();
                }
            });
        }
    };
})
.directive('ckEditor', function () {
    return {
        require: '?ngModel',
        link: function (scope, elm, attr, ngModel) {
            var ck = CKEDITOR.replace(elm[0]);

            if (!ngModel) return;

            ck.on('pasteState', function () {
                scope.$apply(function () {
                    ngModel.$setViewValue(ck.getData());
                });
            });

            ngModel.$render = function (value) {
                ck.setData(ngModel.$viewValue);
            };
        }
    };
})
.directive('numbersOnly', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModelCtrl) {
            function fromUser(text) {
                if (text) {
                    var transformedInput = text.replace(/[^0-9]/g, '');

                    if (transformedInput !== text) {
                        ngModelCtrl.$setViewValue(transformedInput);
                        ngModelCtrl.$render();
                    }
                    return transformedInput;
                }
                return undefined;
            }
            ngModelCtrl.$parsers.push(fromUser);
        }
    };
})
.directive('numbersOnly', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModelCtrl) {
            function fromUser(text) {
                if (text) {
                    var transformedInput = text.replace(/[^0-9]/g, '');

                    if (transformedInput !== text) {
                        ngModelCtrl.$setViewValue(transformedInput);
                        ngModelCtrl.$render();
                    }
                    return transformedInput;
                }
                return undefined;
            }
            ngModelCtrl.$parsers.push(fromUser);
        }
    };
})
  .directive('loading', ['$http', function ($http) {
      return {
          restrict: 'A',
          link: function (scope, elm, attrs) {
              scope.isLoading = function () {
                  return $http.pendingRequests.length > 0;
              };

              scope.$watch(scope.isLoading, function (v) {
                  if (v) {
                      elm.show();
                  } else {
                      elm.hide();
                  }
              });
          }
      };

  }])
.config(['$httpProvider', function($httpProvider) {
    //initialize get if not there
    if (!$httpProvider.defaults.headers.get) {
        $httpProvider.defaults.headers.get = {};    
    }    

    // Answer edited to include suggestions from comments
    // because previous version of code introduced browser-related errors

    //disable IE ajax request caching
    $httpProvider.defaults.headers.get['If-Modified-Since'] = 'Mon, 26 Jul 1997 05:00:00 GMT';
    // extra
    $httpProvider.defaults.headers.get['Cache-Control'] = 'no-cache';
    $httpProvider.defaults.headers.get['Pragma'] = 'no-cache';
}])
.run(function ($rootScope, $templateCache) {
    $rootScope.$on('$viewContentLoaded', function () {
        $templateCache.removeAll();
    });
});

//.directive('restrictInput', function () {
//    return {
//        restrict: 'A',
//        require: 'ngModel',
//        link: function (scope, element, attr, ctrl) {
//            ctrl.$parsers.unshift(function (viewValue) {
//                var options = scope.$eval(attr.restrictInput);
//                if (!options.regex && options.type) {
//                    switch (options.type) {
//                        case 'digitsOnly': options.regex = '^[0-9]*$'; break;
//                        case 'lettersOnly': options.regex = '^[a-zA-Z]*$'; break;
//                        case 'lowercaseLettersOnly': options.regex = '^[a-z]*$'; break;
//                        case 'uppercaseLettersOnly': options.regex = '^[A-Z]*$'; break;
//                        case 'lettersAndDigitsOnly': options.regex = '^[a-zA-Z0-9]*$'; break;
//                        case 'validPhoneCharsOnly': options.regex = '^[0-9 ()/-]*$'; break;
//                        default: options.regex = '';
//                    }
//                }
//                var reg = new RegExp(options.regex);
//                if (reg.test(viewValue)) { //if valid view value, return it
//                    return viewValue;
//                } else { //if not valid view value, use the model value (or empty string if that's also invalid)
//                    var overrideValue = (reg.test(ctrl.$modelValue) ? ctrl.$modelValue : '');
//                    element.val(overrideValue);
//                    return overrideValue;
//                }
//            });
//        }
//    };
//});
//.directive('autoComplete', function ($timeout) {
//    return function (scope, iElement, iAttrs) {
//        iElement.autocomplete({
//            source: scope[iAttrs.uiItems],
//            select: function () {
//                $timeout(function () {
//                    iElement.trigger('input');
//                }, 0);
//            }
//        });
//    };
//});