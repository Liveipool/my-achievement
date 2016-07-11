(function() {
  'use strict';

  angular
    .module('fuse')
    .factory('Authentication', AuthenticationService);

  function AuthenticationService($resource, $q, $cookies) {
    var self = this,
        authticatedUser = null;

    return {

      isExists: function() {
        return authticatedUser !== null;
      },

      getUser: function() {
        return authticatedUser;
      },

      getCookieUser: function() {
        var deferred = $q.defer();

        var cookieUser = $cookies.getObject("cookieUser");
        if (cookieUser) {
          authticatedUser = cookieUser;
        }
        deferred.resolve(authticatedUser);

        return deferred.promise;

      },

      login: function(params) {
        return $resource('app/data/auth/users.json').get().$promise.then(function(result) {

          var users = result.user;

          for (var i = users.length - 1; i >= 0; i--) {
            if (users[i].username === params.username && users[i].password === params.password) {
              authticatedUser = users[i];
              $cookies.putObject("cookieUser", authticatedUser);
              return Promise.resolve(authticatedUser);
            }
          }

          return Promise.resolve(authticatedUser);
        });

      },

      logout: function() {
        authticatedUser = null;
        $cookies.remove("cookieUser");
      },

      filterRoute: function(user) {
        switch (user.role) {
          case 'student':
            return 'app.student.homework-dashboard';
            break;
          case 'teacher':
            return 'app.teacher.homework-list' //'app.teacher.homework.dashboard';
            break;
          case 'admin':
            return 'app.admin.all-users' // 'app.admin.dashboard';
            break;
          case 'ta':
            return 'app.TA.review-list' // 'app.ta.homework.dashboard';
            break;
          default:
            return 'app.login';
            break;
        }
      }

    }
  }

})();