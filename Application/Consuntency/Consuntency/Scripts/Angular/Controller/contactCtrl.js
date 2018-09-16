angular.module('myApp').controller('contactCtrl', function ($scope, $http, commonService, $filter) {
    $scope.divContact = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
  
    $scope.co = {};
    $scope.co.preName = 'None';
    $scope.saveContact = function (p) {
        var x = $('#formContact');
        var status = $(x).ValidationFunction();
        debugger;
        if (status == false) {
            return false;
        }
        $scope.btnSave = 0;
        $http.post('/Contact/saveContact', { co: $scope.co }).then(function (response) {
            console.log(response);
            
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.getContact();
            if (response.data.msg == 's') {
                showSuccessToast("Saved Successfully.");
                $scope.clear();
                $scope.btnSave = 1;
                if (p == 'n') {
                    $scope.divContact = 0;
                }
                else {
                    $scope.divContact = 1;
                }

            }
            else {
                showNoticeToast("Failed!Try Again.");
                $scope.clear();
                $scope.btnSave = 1;
            }
        }, function (error) {
            

        })
    }
    $scope.getContact = function (p) {
        //var x = $('#formJobOpeningInfo');
        //var status = $(x).ValidationFunction();
        //if (status == false) {
        //    return false;
        //}

        $http.get('/Contact/getContact?clientId='+0).then(function (response) {
            console.log(response);
            $scope.listContact = response.data.listContact;
            commonService.setTimeout_OnDatatable();
            //if (response.data.msg == 's') {
            //}
            //else {
            //    showSuccessToast("Saved Successfully.");

            //}

        }, function (error) {
        })
    };
    $scope.clear = function () {
        $scope.co = {};
        $scope.co.preName = 'None';
    }
    $scope.new = function () {
        $scope.divContact = 0;
    }
    $scope.editContact = function () {

        angular.forEach($scope.listContact, function (element, index) {

            if (element.chkbox == true) {
                $scope.co = angular.copy(element);
                return false;
            }

        })
        $scope.divContact = 0;

    }
    
    $scope.deleteContact = function () {
        var Ids = '';
        angular.forEach($scope.listContact, function (element, index) {

            if (element.chkbox == true) {
                console.log(Ids);
                Ids += element.contactId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            console.log(Ids);
            $http.post('/Contact/deleteContact', { contactIds: Ids }).then(function (response) {
                console.log(response);
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                $scope.getContact();

                if (response.data.msg == 's') {
                    showSuccessToast("Delete Successfully.");
                }
                else if (response.data.msg == "ec") {
                    showStickyErrorToast("This Record are Not Deleted because They are   Currently In use.");
                }

                else {
                    showNoticeToast("Failed!Try Again.");
                }
            }, function (error) {
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                $scope.getContact();
            })
        }
    }
    $scope.allChkboxChecked_UnChecked = function () {
        angular.forEach($scope.listContact, function (element, index) {
            if ($scope.chkboxHeader == true) {
                element.chkbox = true;
            }
            else if ($scope.chkboxHeader == false) {
                element.chkbox = false;
            }
        })
        $scope.checkEditDelete();
    }

    $scope.checkEditDelete = function () {
        var i = 0;
        angular.forEach($scope.listContact, function (element, index) {

            if (element.chkbox == true) {
                i = i + 1;
            }

        })
        if (i > 0) {
            $scope.btnNew = 0;
            $scope.btnEdit = 1;
            $scope.btnDelete = 1;

            if (i > 1) {
                $scope.btnEdit = 0;
            }

        }

        else {

            $scope.btnEdit = 0;
            $scope.btnDelete = 0;
            $scope.btnNew = 1;
        }
    }

    $scope.getClient = function (p) {

        $http.get('/Client/getClient').then(function (response) {
            console.log(response);
            $scope.listClient = response.data.listClient;
    
        }, function (error) {
        })
    }
    $scope.cancel = function () {
        //location.reload();
        $scope.clear();
        $('input,select').removeClass('error');
        $scope.divContact = 1;
    }
    $scope.getClient();
    $scope.getContact();
 

})