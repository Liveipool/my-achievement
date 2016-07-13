(function() {
  'use strict';

  angular
    .module('fuse')
    .factory('Authentication', AuthenticationService)
    .factory('Interaction', InteractionService);

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
      },

      isntAdmin: function(user) {
        return user.role !== 'admin';
      },

      isntStudent: function(user) {
        return user.role !== 'student';
      },

      isntTeacher: function(user) {
        return user.role !== 'teacher';
      },

      isntTA: function(user) {
        return user.role !== 'ta';
      },

      isToStateAuthenticated: function(toState) {
        // some states which do not have 'data' or do not have 'data.role' attr can be  visited, e.g. 'profile' state, 'login' state, 'access-denied' state
        // states that have same  'data.role' attr as user role can be visited
          return !toState.data || !toState.data.role || toState.data.role == this.getUser().role
      }

    }
  }

  function InteractionService (){
    return {
      getBgByMonth: function (number) {
        var season,
            month = number; //#TODO 测试用，实际部署时使用new Date().getMonth()

        if (month >= 0 && month <= 2)
          season = "spring";

        else if (month >= 3 && month <= 5)
          season = "summer";

        else if (month >=6 && month <= 8)
          season = "autumn";

        else
          season = "winter";
        switch  (season) {
          case "spring":
            return {
              fg: 'default-fg',
              bg: 'spring'
            };
            break;
          case "summer":
            return {
              fg: 'default-fg',
              bg: 'summer'
            };
            break;
          case "autumn":
            return {
              fg: 'default-fg',
              bg: 'autumn'
            };
            break;
          case "winter":
            return {
              fg: 'default-fg',
              bg: 'winter'
            };
            break;
          default:
            return {
              fg: 'default-fg',
              bg: 'spring'
            };
        }
      }
  }
}
})();
