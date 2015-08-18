(function ()
{
    'use strict';

    angular.module('fuse')
        .directive('msTimeline', msTimeline);

    /** @ngInject */
    function msTimeline($window, $timeout)
    {
        return {
            scope: true,
            link : function ($scope, $element)
            {
                var vm = $scope.vm;
                var timelineHeight;
                vm.limit = 1;

                var scrollEl = angular.element('#content > md-content');

                // Timeline Item Template Loaded
                $scope.$on('$includeContentLoaded', function ()
                {
                    // Images loaded in timeline item
                    $element.find('img').bind('load', function ()
                    {
                        console.log('images loaded');
                        timelineHeight = $element.outerHeight();
                        checkHeights();
                    });

                });

                // If timeline height smaller than content height
                // adds one item more
                function checkHeights()
                {
                    console.log(scrollEl.outerHeight());
                    console.log(timelineHeight);

                    if ( timelineHeight < scrollEl.outerHeight() )
                    {
                        addItem();
                    }

                }

                function addItem()
                {
                    $timeout(function ()
                    {
                        vm.limit++;
                    });
                }


                // On Content scroll
                scrollEl.on('scroll', function ()
                {
                    console.log('scrolled');
                    if ( scrollEl[0].scrollTop + scrollEl[0].offsetHeight >= scrollEl[0].scrollHeight )
                    {
                        addItem();
                        console.log('limit increased');
                    }

                });
            }
        };
    }
})();
