angular.module('myApp').controller('emailTemplateCtrl', function ($scope, $http, commonService, $filter,$sce) {
    $scope.divEmailTemplate = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
    $scope.tempDescription;

    $scope.e = {};
    $scope.saveEmailTemplate = function (p) {
        var x = $('#formEmailTemplate');
        var status = $(x).ValidationFunction();
        debugger;
        if (status == false) {
            return false;
        }
        $scope.btnSave = 0;
        $http.post('/EmailTemplate/saveEmailTemplate', { e: $scope.e }).then(function (response) {
            console.log(response);
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.getEmailTemplate();
            if (response.data.msg == 's') {
                showSuccessToast("Saved Successfully.");
                $scope.clear();
                $scope.btnSave = 1;
                if (p == 'n') {
                    $scope.divEmailTemplate = 0;
                }
                else {
                    $scope.divEmailTemplate = 1;
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
    $scope.getEmailTemplate = function (p) {
        

        $http.get('/EmailTemplate/getEmailTemplate').then(function (response) {
            console.log(response);
            $scope.listET = response.data.listET;
            commonService.setTimeout_OnDatatable();
        }, function (error) {
        })
    };
    $scope.clear = function () {
        $scope.e = {};
    }
    $scope.new = function () {
        $scope.divEmailTemplate = 0;
    }
    $scope.editContact = function () {

        angular.forEach($scope.listET, function (element, index) {

            if (element.chkbox == true) {
                $scope.e = angular.copy(element);
                return false;
            }

        })
        $scope.divEmailTemplate = 0;

    }

    $scope.deleteEmailTemplate = function () {
        var Ids = '';
        angular.forEach($scope.listET, function (element, index) {

            if (element.chkbox == true) {
                console.log(Ids);
                Ids += element.etId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            console.log(Ids);
            $http.post('/EmailTemplate/deleteEmailTemplate', { etIds: Ids }).then(function (response) {
                console.log(response);
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                $scope.getEmailTemplate();

                if (response.data.msg == 's') {
                    showSuccessToast("Delete Successfully.");
                }
                else {
                    showNoticeToast("Failed!Try Again.");
                }
            }, function (error) {
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                $scope.getEmailTemplate();
            })
        }
    }
    $scope.allChkboxChecked_UnChecked = function () {
        angular.forEach($scope.listET, function (element, index) {
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
        angular.forEach($scope.listET, function (element, index) {

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
        $scope.clear();
        $scope.divEmailTemplate = 1;
        //location.reload();
    }
    $scope.showModalDescription = function (description) {
        $scope.tempDescription = description;
        $('#ModalDescription').modal('show');
    }
    $scope.trustAsHtml = function (string) {
        return $sce.trustAsHtml(string);
    };
    
    $scope.getEmailTemplate();


})