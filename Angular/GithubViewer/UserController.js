(function(){

    var app = angular.module("githubViewer"); 

    var UserController = function($scope, $http, $routeParams) {

        var onUserComplete = function(response){
            $scope.user = response.data;
            $http.get($scope.user.repos_url)
                .then(onRepos, onError);
        };
    
        var onRepos = function(response) {
            $scope.repos = response.data;
            $location.hash("userDetails");
            $anchorScroll();
        }

        var onError = function(reason) {
            $scope.error = "Could not fetch the data"; 
            console.log(reason);
        }; 
    
        $scope.username = $routeParams.username;
        $scope.repoSortOrder = "-stargazers_count";
    }; 

    app.controller("UserController", UserController);
}()); 

