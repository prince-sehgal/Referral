angular.module('myApp').controller('sendEmailCtrl', function ($scope, $http) {

    var _candidateIds = $('#candidateIds').val();

    $scope.getEmailTemplate = function () {


        $http.get('/EmailTemplate/getEmailTemplate').then(function (response) {
            console.log(response);
            $scope.listET = response.data.listET;

        }, function (error) {
        })
    }


    $scope.getEmailTemplate_byEtId = function () {
        angular.forEach($scope.listET, function (element,index) {
            if(element.etId==$scope.etId)
            {
                $scope.e =angular.copy(element);
            }
        })
    }
    $scope.getCandidateEmailId_byCandidateIds = function (p) {


        $http.get('/SendEmail/getCandidateEmailId_byCandidateIds?candidateIds=' + _candidateIds).then(function (response) {
            console.log(response);
            $scope.listEmailId = response.data.listEmailId;

        }, function (error) {
        })
    }
    $scope.getCandidateEmailId_byCandidateIds();
    $scope.getEmailTemplate();
})

