angular.module('myApp').controller('manageUserCtrl', function ($scope, $http,commonService) {
    $scope.u = {};
    $scope.u.status = "Active";
    $scope.divET = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
    $scope.u.recruitmetLeadId = 0;
    var errMsg = '';
    var v = 0;
    $scope.saveUser = function (p) {
        v = 0;
        var x = $('#formManageUser');
        var status = $(x).ValidationFunction();
        if (status == false) {
            return false;
        }
        //debugger;
        if ($scope.u.mobileNo.length < 10)
        {
            errMsg = '<p>Please Enter Correct Mobile No</p>';
            commonService.showErrorPopup(errMsg);
            return false;
        }
        if ($scope.u.password !=$scope.u.confirmPassword)
        {
            errMsg = '<p>Password is not  Match</p>';
            commonService.showErrorPopup(errMsg);
            return false;
        }
        $http.post('/User/checkExistsEmailId_MobileNo', { u: $scope.u }).then(function (response) {
            //console.log(response);
            errMsg = '';
            if( response.data.firstNameStatus == 1)
            {
                errMsg += "<p>First Name Is already Exists! Please Enter Another Name</p>";
                v += 1;
            }
            if (response.data.emailIdStatus == 1) {
                errMsg += "<p>EmailID Is already Exists! Please Enter Another EmailID</p>";
                v += 1;
                }
               
               if( response.data.mobileNoStatus == 1)
                {
                   errMsg += "<p>Mobile Number Is already Exists! Please Enter Another Mobile Number</p>";
                   v += 1;
               }
               if (v > 0) {
                   commonService.showErrorPopup(errMsg);
                   return false;
               }
             
               else if (v == 0) {
                   $scope.btnSave = 0;
                    $http.post('/User/saveUser', { u: $scope.u }).then(function (response) {
                        //console.log(response);
                        $scope.chkboxHeader = false;
                        $scope.allChkboxChecked_UnChecked();
                        $scope.getUser();
                        $scope.getRecruitmetLead();
                        if (response.data.msg == 's') {

                            showSuccessToast("Saved Successfully.");
                            $scope.clear();
                            $scope.btnSave = 1;
                            if (p == 'n') {
                                $scope.divET = 0;
                            }
                            else {
                                $scope.divET = 1;
                            }

                        }
                        else {
                            showNoticeToast("Failed!Try Again.");
                            $scope.clear();
                            $scope.btnSave = 1;
                        }
                    }, function (error) {
                        $scope.btnSave = 1;
                    })
                }
        }, function (error) {
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.btnSave = 1;
        })
        
    }

    $scope.getUser = function () {
        $http.get('/User/getUser').then(function (response) {
            //console.log(response);
            $scope.listUser = response.data.listUser;
            $scope.u.status = "Active";
            commonService.setTimeout_OnDatatable();
        }, function (error) {
        })
    }
    $scope.divShowHide = function (p) {
        $scope.divET = p;
    }
    $scope.rowclickUser = function () {
        $scope.u = angular.copy(this.us);
        $scope.divET = 0;
    }
    $scope.clear = function () {
        $scope.u = {};
        $scope.u.status = "Active";
    }
    //$scope.deleteUser = function (p) {
    //    $http.post('/User/deleteUser', { userId:this.us.userId }).then(function (response) {
    //        console.log(response);
    //        $scope.getUser();
    //        if (response.data.msg == 's') {
    //            showSuccessToast("Delete Successfully.");
    //            $scope.clear();
    //            $scope.btnDelete = 0;
    //            $scope.btnSave = 1;
    //            if (p == 'n') {
    //                $scope.divET = 0;
    //            }
    //            else {
    //                $scope.divET = 1;
    //            }
    //        }
    //        else {
    //            showNoticeToast("Failed!Try Again.");
    //            $scope.clear();
    //            $scope.btnSave = 1;
    //        }
    //    }, function (error) {
    //        $scope.btnSave = 1;
    //    })
    //}
    $scope.getRecruitmetLead = function () {
        $http.get('/User/getRecruitmetLead').then(function (response) {
            //console.log(response);
            $scope.listRecruitmetLead = response.data.listRecruitmetLead;
        }, function (error) {
        })
    }
    $scope.addClassOnRecruitmetLead = function () {
        if($scope.u.role=='Recruiter')
        {
            $('#rId').addClass("form-control validate[required,'Please Select AnyOne In Recruitmet Lead']");
            $('#mn').removeClass();
        }
        else if ($scope.u.role == 'Recruitmet Lead') {
            $('#mn').addClass("form-control validate[required,'Please Enter Manager Name']");
            $('#rId').removeClass();
        }
        else {
            $('#rId').removeClass();
            $('#mn').removeClass();
        }
    }
    $scope.new = function () {
        $scope.divET = 0;
    }
    $scope.editUser = function () {
        
        angular.forEach($scope.listUser, function (element, index) {

            if (element.chkbox == true) {
                $scope.u = angular.copy(element);
                $scope.addClassOnRecruitmetLead();
                return false;
            }

        })
        $scope.divET = 0;
   
    }
    $scope.deleteUser = function () {
        var Ids = '';
        angular.forEach($scope.listUser, function (element, index) {

            if (element.chkbox == true) {
                //console.log(Ids);
                Ids += element.userId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            //console.log(Ids);
            $http.post('/User/deleteUser', { userIds: Ids }).then(function (response) {
                //console.log(response);
                $scope.getUser();
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
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

            })
        }
    }
    $scope.allChkboxChecked_UnChecked = function () {
        angular.forEach($scope.listUser, function (element, index) {
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
        angular.forEach($scope.listUser, function (element, index) {

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
    $scope.cancel = function () {
        $scope.clear();
        $('input,select').removeClass('error');
        $scope.divET = 1;
    }
    $scope.dataTableOpt = {
   //custom datatable options 
  // or load data through ajax call also
  "aLengthMenu": [[10, 50, 100,-1], [10, 50, 100,'All']],
  };

    $scope.getUser();
    $scope.getRecruitmetLead();
})