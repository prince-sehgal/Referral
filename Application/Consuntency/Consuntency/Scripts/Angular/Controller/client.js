angular.module('myApp').controller('clientCtrl', function ($scope, $http, commonService, $filter) {
    $scope.divClient = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
    $scope.c = {};
    $scope.saveClient = function (p) {
        var x = $('#formClient');
        var status = $(x).ValidationFunction();
        debugger;
        if (status == false) {
            return false;
        }
        $scope.btnSave = 0;
        $http.post('/Client/saveClient', { c: $scope.c, listAccountManager: $scope.listAccountManager }).then(function (response) {
            //console.log(response);
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.getClient();
            if (response.data.msg == 's') {
                showSuccessToast("Saved Successfully.");
                $scope.clear();
                
                $scope.getRecruiter_byRecruitmetLeadId();
                $scope.btnSave = 1;
                if (p == 'n') {
                    $scope.divClient = 0;
                }
                else {
                    $scope.divClient = 1;
                }

            }
            else {
                showNoticeToast("Failed!Try Again.");
                $scope.clear();
               
                $scope.getRecruiter_byRecruitmetLeadId();
                $scope.btnSave = 1;
            }
        }, function (error) {
        })
    }
    $scope.getClient = function (p) {
        //var x = $('#formJobOpeningInfo');
        //var status = $(x).ValidationFunction();
        //if (status == false) {
        //    return false;
        //}

        $http.get('/Client/getClient').then(function (response) {
            //console.log(response);
            $scope.listClient = response.data.listClient;
            $scope.listAM = response.data.listAM;
            commonService.setTimeout_OnDatatable();
        }, function (error) {
        })
    };
    //$scope.getClient_AccountManager = function (p) {
    //    $http.get('/Client/getClient_AccountManager').then(function (response) {
    //        //console.log(response);
    //        $scope.listAM = response.data.listAM;
    //    }, function (error) {
    //    })
    //};
    $scope.showModalAccountManager = function (clientId) {
        $scope.temp_listAM = [];
        angular.forEach($scope.listAM, function (element, index) {
            if (element.clientId == clientId) {
                $scope.temp_listAM.push(element);
                debugger;
                //console.log(element);
            }

        })
        $('#ModalAccountManager').modal('show');
        
        
    }
    $scope.clear = function () {
        $scope.c = {};
        $scope.c.recruitmetLeadId=0;
        $scope.listAccountManager = [];
    }
    $scope.new = function () {
        $scope.divClient = 0;
    }
    $scope.editClient = function () {

        angular.forEach($scope.listClient, function (element, index) {

            if (element.chkbox == true) {
                $scope.c = angular.copy(element);
                $scope.getRecruiter_byRecruitmetLeadId();
                $scope.listAccountManager = [];
                angular.forEach($scope.listAM, function (element, index) {
                    if (element.clientId == $scope.c.clientId) {
                        $scope.listAccountManager.push(element);
                        debugger;
                        //console.log(element);
                    }

                })
                return false;
            }

        })
        $scope.divClient = 0;

    }
    $scope.getRecruitmetLead = function () {
        $http.get('/User/getRecruitmetLead').then(function (response) {
            //console.log(response);
            $scope.listRecruitmetLead = response.data.listRecruitmetLead;
        }, function (error) {
        })
    }
    $scope.deleteClient = function () {
        //$.toaster({ priority: 'success', title: 'Title', message: 'Your message here' , settings : {'timeout':1000000} });
        var Ids = '';
        angular.forEach($scope.listClient, function (element, index) {

            if (element.chkbox == true) {
                //console.log(Ids);
                Ids += element.clientId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            //console.log(Ids);
            $http.post('/Client/deleteClient', { clientIds: Ids }).then(function (response) {
                //console.log(response);
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                $scope.getClient();
          
                if (response.data.msg == 's') {
                    showSuccessToast("Delete Successfully.");
                }
                else if(response.data.msg=="ec")
                {
                    showStickyErrorToast("This Record are Not Deleted because They are   Currently In use.");
                }
                else {
                    showNoticeToast("Failed!Try Again.");
                }
            }, function (error) {
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                $scope.getClient();
            })
        }
    }
    $scope.allChkboxChecked_UnChecked = function () {
        angular.forEach($scope.listClient, function (element, index) {
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
        angular.forEach($scope.listClient, function (element, index) {

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
    $scope.getRecruiter_byRecruitmetLeadId = function () {
        $http.get('/JobOpeningInfo/getRecruiter_byRecruitmetLeadId?recruitmetLeadId=' + $scope.c.recruitmetLeadId).then(function (response) {
            //console.log(response);
            $scope.listRecruiter = response.data.listRecruiter;
        }, function (error) {
        })
    }

    $scope.listAccountManager = [];
    var am = {};
   am.accountManager='';
   $scope.addInlistAccountManager = function (c_amId) {
        $scope.listAccountManager.push(am);
        am = {};
    }
   $scope.deleteClient_AccountManager = function (c_amId,index) {
       if (c_amId != undefined) {
           $http.get('/Client/deleteClient_AccountManager?c_amId=' + c_amId + '&clientId=' + $scope.c.clientId).then(function (response) {
               //console.log(response);
               if (response.data.msg == 's') {
                   $scope.listAccountManager.splice(index, 1);
                   //showSuccessToast("Delete Successfully.");
               }
               else if (response.data.msg == "ec") {
                   showStickyErrorToast("This Record are Not Deleted because They are   Currently In use.");
               }
               else {
                   //showNoticeToast("Failed!Try Again.");
               }

           }, function (error) {
           })
       }
    }
   $scope.cancel = function () {
       //location.reload();
       $scope.clear();
       $('input,select').removeClass('error');
       $scope.divClient = 1;
     
     
   }    
    $scope.getRecruitmetLead();
    $scope.getClient();

})