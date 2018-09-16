angular.module('myApp').controller('jobOpeningInfoCtrl', function ($scope, $http, commonService, $filter) {
    $scope.divJOI = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
    $scope.cr_al == 'al';
    $scope.selectErr = false;
    $scope.j = {};
    $scope.listClient = [];
    //$scope.j.recruitmetLeadId = 0;
    //$scope.j.clientId = 0;
    //$scope.j.contactId = 0;
    $scope.getRecruitmetLead = function () {
        $http.get('/User/getRecruitmetLead').then(function (response) {
            console.log(response);
            $scope.listRecruitmetLead = response.data.listRecruitmetLead;
            //$scope.j = { recruitmetLeadId: $scope.listRecruitmetLead[0].value };
            $scope.j.recruitmetLeadId = 0;
        }, function (error) {
        })
    }

    $scope.getRecruiter_byRecruitmetLeadId = function (p) {
        if (p == 'j') {
            $http.get('/JobOpeningInfo/getRecruiter_byRecruitmetLeadId?recruitmetLeadId=' + $scope.j.recruitmetLeadId).then(function (response) {
                console.log(response);
                $scope.listRecruiter_forJOI = response.data.listRecruiter;
            }, function (error) {
            })
        }
        else if (p == 'c') {
            $http.get('/JobOpeningInfo/getRecruiter_byRecruitmetLeadId?recruitmetLeadId=' + $scope.c.recruitmetLeadId).then(function (response) {
                console.log(response);
                $scope.listRecruiter_forCl = response.data.listRecruiter;
            }, function (error) {
            })
        }
    }

    $scope.saveJobOpeningInfo = function (p) {
        debugger;
        var x = $('#formJobOpeningInfo');
        var status = $(x).ValidationFunction();
        if (status == false) {
            return false;
        }
        debugger;
        $scope.btnSave = 0;
        var j_copy = {};
        j_copy = angular.copy($scope.j);
        if (j_copy.targetDT != undefined && j_copy.targetDT != null && j_copy.targetDT != '') {
            j_copy.targetDT = commonService.convertDateStringToDateObj(j_copy.targetDT);
        }
        if (j_copy.openedDT != undefined && j_copy.openedDT != null && j_copy.openedDT != '') {
            j_copy.openedDT = commonService.convertDateStringToDateObj(j_copy.openedDT);
        }
        $http.post('/JobOpeningInfo/saveJobOpeningInfo', { j: j_copy }).then(function (response) {
            console.log(response);
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            if (response.data.msg == 's') {
                var js;
                debugger;
                //if (window.FormData !== undefined) {
                var fileData = new FormData();
                if ($("#jobSummeryPhoto").val() != '') {
                    fileData.append($("#jobSummeryPhoto").get(0).files[0].name, $("#jobSummeryPhoto").get(0).files[0]);
                    js = "yes";
                    $http({
                        url: '/JobOpeningInfo/saveJobSummeryPhoto_Doc?js=' + js + '&joiId=' + response.data.joiId,
                        method: 'POST',
                        data: fileData,
                        headers: { 'Content-Type': undefined },
                        transformRequest: angular.identity
                    }).then(function (resPhoto) {
                        console.log(resPhoto);
                        console.log(response);
                        if (resPhoto.data.msg == 's') {
                            showSuccessToast("Saved Successfully.");
                            $scope.getJobOpeningInfo();
                            $scope.clearJobOpeningInfo();
                            $scope.btnSave = 1;
                            if (p == 'n') {
                                $scope.divJOI = 0;
                            }
                            else {
                                $scope.divJOI = 1;
                            }
                        }
                        $("#jobSummeryPhoto").val('');
                    }, function (errorPhoto) {
                        $("#jobSummeryPhoto").val();
                        $scope.btnSave = 1;

                    })
                }

                    //}
                else {
                    showSuccessToast("Saved Successfully.");
                    $scope.getJobOpeningInfo();
                    $scope.clearJobOpeningInfo();
                    $scope.btnSave = 1;

                    if (p == 'n') {
                        $scope.divJOI = 0;
                    }
                    else {
                        $scope.divJOI = 1;
                    }
                }
            }
            else {
                showNoticeToast("Failed!Try Again.");
                $scope.getJobOpeningInfo();
                $scope.clearJobOpeningInfo();
                $scope.btnSave = 1;
            }
        }, function (error) {
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.btnSave = 1;
        })
    }
    $scope.getJobOpeningInfo = function () {
        $http.get('/JobOpeningInfo/getJobOpeningInfo?clientId=' + 0).then(function (response) {
            console.log(response);
            $scope.listJobOpeningInfo = response.data.listJobOpeningInfo;
            angular.forEach($scope.listJobOpeningInfo, function (element, index) {
                element.targetDT = $filter('date')(element.targetDT.slice(6, -2), 'dd-MM-yyyy');
                //element.openedDT = $filter('date')(element.openedDT.slice(6, -2), 'dd-MM-yyyy');
            })
            commonService.setTimeout_OnDatatable();
            //setTimeout(function () {
            //    $('.dataTable').DataTable();
            //}, 1000)



        }, function (error) {
        })
    }


    $scope.clearJobOpeningInfo = function () {
        $scope.j = {};
        //$scope.j.clientId = 0;
        //$scope.j.contactId = 0;
    }
    $scope.clearClient = function () {
        $scope.c = {};
        $scope.listAccountManager = [];
        $scope.c.recruiterId = 0;

    }
    $scope.divShowHide = function (p) {
        $scope.divJOI = p;
    }
    $scope.editJobOPeningInfo = function () {
        $scope.cr_al = '';
        //$scope.j = angular.copy(this.jo);
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {

            if (element.chkbox == true) {
                $scope.j = angular.copy(element);
                $scope.divJOI = 0;
                $scope.getRecruiter_byRecruitmetLeadId('j');
                $scope.getContact($scope.j.clientId);
                return false;
            }

        })


    }
    $scope.deleteJobOpeningInfo = function () {
        var Ids = '';
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {

            if (element.chkbox == true) {
                console.log(Ids);
                Ids += element.joiId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            console.log(Ids);
            $http.post('/JobOpeningInfo/deleteJobOpeningInfo', { joiIds: Ids }).then(function (response) {
                console.log(response);
                $scope.getJobOpeningInfo();
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
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {
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
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {

            if (element.chkbox == true) {
                i = i + 1;
            }

        })
        if (i > 0) {

            $scope.btnEdit = 1;
            $scope.btnDelete = 1;
            $scope.btnNew = 0;
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
    $scope.new = function () {
        $scope.divJOI = 0;
    }

    $scope.c = {};
    $scope.saveClient = function (p) {
        var x = $('#formModelClient');
        var status = $(x).ValidationFunction();
        if (status == false) {
            return false;
        }

        $http.post('/Client/saveClient', { c: $scope.c, listAccountManager: $scope.listAccountManager }).then(function (response) {
            console.log(response);

            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.j.clientId = response.data.clientId;
            $scope.clearClient();
            if (response.data.msg == 's') {
                //showSuccessToast("Saved Successfully.");
                debugger;
                $scope.btnSave = 1;
                //$scope.getRecruiter_byRecruitmetLeadId('c');
                if (p == 'a') {
                    $scope.j.clientId = response.data.clientId;
                    $scope.setRecruiterLeadId_and_Recruiter_byClientId();
                    $scope.hide_Modal();

                }
                else {
                    $scope.show_getClientModal();
                }

            }
            else {
                showNoticeToast("Failed!Try Again.");
                $scope.clearClient();
                $scope.btnSave = 1;
                //$scope.getRecruiter_byRecruitmetLeadId('c');
            }

        }, function (error) {
        })
    }
    $scope.getClient = function (p) {
        $http.get('/Client/getClient').then(function (response) {
            console.log(response);
            $scope.listClient = response.data.listClient;

        }, function (error) {
        })
    }
    $scope.show_saveClientModal = function () {
        $('#getClientModal').modal('hide');
        $('#saveClientModal').modal('show');

    }
    $scope.show_getClientModal = function () {
        $('#saveClientModal').modal('hide');
        $('#getClientModal').modal('show');

    }
    $scope.show_saveContactModal = function () {
        $('#getContactModal').modal('hide');
        $('#saveContactModal').modal('show');

    }
    $scope.show_getContactModal = function () {
        $('#saveContactModal').modal('hide');
        $('#getContactModal').modal('show');

    }
    $scope.hide_Modal = function () {
        $('#saveClientModal').modal('hide');
        $('#getClientModal').modal('hide');
        $('#getContactModal').modal('hide');
        $('#saveContactModal').modal('hide');

    }
    $scope.co = {};
    $scope.saveContact = function (p) {
        var x = $('#formModelContact');
        var status = $(x).ValidationFunction();
        debugger;
        if (status == false) {

            return false;
        }
        //if (status == false || $scope.co.clientId == undefined) {
        //    if ($scope.co.clientId == undefined) {
        //        $scope.selectErr = true;
        //    }
        //    return false;
        //}

        $http.post('/Contact/saveContact', { co: $scope.co }).then(function (response) {
            console.log(response);


            if (response.data.msg = 's') {
                if (p == 'a') {
                    //alert($scope.co.clientId);
                    $scope.j.contactId = response.data.contactId;
                    $scope.j.clientId = $scope.co.clientId;
                    $scope.getContact(0);
                    $scope.setRecruiterLeadId_and_Recruiter_byClientId();
                    //alert($scope.j.clientId);
                    $scope.co = {};
                    $scope.hide_Modal();
                }
                else {
                    //$scope.show_getContactModal();
                    $scope.co = {};
                    $scope.getContact(0);
                    $scope.show_getContactModal();
                }
            }
        }, function (error) {
        })
    }
    //$scope.isBlankSelect = function (p) {
    //    if(p=='' || p==undefined || p==null)
    //    {
    //        $scope.selectErr = true;
    //    }
    //    else {
    //        $scope.selectErr = false;
    //    }
    //}
    $scope.getContact = function (clientId) {
        debugger;

        if ($scope.cr_al == 'al') {
            clientId = 0;
        }

        else {
            if (clientId == null) {
                clientId = 0;
            }
            else if (clientId > 0) {
                $scope.cr_al = 'cr';

            }
        }

        $scope.co.clientId = $scope.j.clientId;
        $scope.getClient_AccountManager_byClientId();

        angular.forEach($scope.listClient, function (element, index) {
            if (element.clientId == $scope.j.clientId) {
                $scope.contactRelated = element.clientName;

                element.isChecked = true;
                return false;
            }
        })
        var tempClienId = 0;
        $http.get('/Contact/getContact?clientId=' + clientId).then(function (response) {
            console.log(response);
            $scope.listContact = response.data.listContact;
            if ($scope.j.contactId > 0) {
                angular.forEach($scope.listContact, function (element, index) {
                    if (element.contactId == $scope.j.contactId) {
                        element.isChecked = true;
                        tempClienId = element.clientId;
                        return false;
                    }

                })
            }
        }, function (error) {
        })
        if ($scope.j.clientId == null || $scope.j.clientId == undefined || $scope.j.clientId == '') {
            $scope.j.clientId = 0;
        }
        $http.get('/Contact/getContact?clientId=' + $scope.j.clientId).then(function (response) {
            console.log(response);
            $scope.listContact_forJobOpen = response.data.listContact;
        }, function (error) {
        })




    }
    $scope.setClientId = function () {
        angular.forEach($scope.listContact, function (element, index) {
            debugger;
            if (element.contactId == $scope.j.contactId) {
                $scope.j.clientId = element.clientId;
                $scope.getContact($scope.j.clientId);
                $scope.getClient_AccountManager_byClientId();
            }

        })

    }
    $scope.listAccountManager = [];
    var am = {};
    am.accountManager = '';
    $scope.addInlistAccountManager = function (c_amId) {
        $scope.listAccountManager.push(am);
        am = {};
    }
    $scope.deleteClient_AccountManager = function (c_amId, index) {
        $scope.listAccountManager.splice(index, 1);
        if (c_amId != undefined) {
            $http.get('/Client/deleteClient_AccountManager?c_amId=' + c_amId + '&clientId=' + $scope.clientId).then(function (response) {
                console.log(response);

            }, function (error) {
            })
        }
    }
    $scope.sendJoiId__To_showJobOpenInfo = function (joiId) {

        window.location = "/JobOpeningInfo/showJobOpenInfo?joiId=" + joiId;

    }
    var joiId;
    joiId = $('#joiId').val();
    $scope.getJobOpeningInfo_byJoiId = function () {
        $http.get('/JobOpeningInfo/getJobOpeningInfo_byJoiId?joiId=' + joiId).then(function (response) {
            console.log(response);
            $scope.j = response.data.j;
            if ($scope.j.targetDT != null && $scope.j.targetDT != undefined && $scope.j.targetDT != '') {
                $scope.j.targetDT = $filter('date')($scope.j.targetDT.slice(6, -2), 'dd-MM-yyyy');
            }
            //if ($scope.j.openedDT != null && $scope.j.openedDT != undefined && $scope.j.openedDT != '') {
            //    $scope.j.openedDT = $filter('date')($scope.j.openedDT.slice(6, -2), 'dd-MM-yyyy');
            //}
        }, function (error) {
        })
    }
    $scope.cancel = function () {
        $scope.clearJobOpeningInfo();
        $('input,select').removeClass('error');
        $scope.divJOI = 1;
    }

    $scope.getClient_AccountManager_byClientId = function () {
        $http.get('/Interviews/getClient_AccountManager_byClientId?clientId=' + $scope.j.clientId).then(function (response) {
            console.log(response);
            $scope.listAM = response.data.listAM;

        }, function (error) {
        })
    }
    //var myfile = "";



    //$('#jobSummeryPhoto').on('change', function () {
    //    myfile = $(this).val();
    //    var ext = myfile.split('.').pop();
    //    if (ext == "pdf" || ext == "docx" || ext == "doc") {

    //    } else {
    //        $('#jobSummeryPhoto').val('');
    //        alert("Please Select Only Pdf and Document");

    //    }
    //});

    //$scope.$watch('j.clientId', function () {
    //    $scope.j.recruitmetLeadId = 0;
    //    $scope.j.recruiterId = 0;

    //    angular.forEach($scope.listClient, function (element, index) {
    //        if(element.clientId==$scope.j.clientId)
    //        {
    //            element.isChecked = true;
    //            $scope.j.recruitmetLeadId = element.recruitmetLeadId;
    //            $scope.getRecruiter_byRecruitmetLeadId('j');
    //            $scope.j.recruiterId = element.recruiterId;

    //        }

    //    })
    //});

    $scope.setRecruiterLeadId_and_Recruiter_byClientId = function () {
        $http.get('/Client/getClient').then(function (response) {
            console.log(response);
            $scope.listClient = response.data.listClient;

            angular.forEach($scope.listClient, function (element, index) {
                if (element.clientId == $scope.j.clientId) {
                    element.isChecked = true;
                    $scope.j.recruitmetLeadId = element.recruitmetLeadId;
                    $scope.getRecruiter_byRecruitmetLeadId('j');
                    $scope.j.recruiterId = element.recruiterId;
                    return false;
                }
            })
        }, function (error) {
        })

    }
    $scope.currentDate = new Date();
    $scope.currentDate = $filter('date')($scope.currentDate, 'dd-MMM-yyyy');

    $scope.getRecruitmetLead();
    $scope.getJobOpeningInfo();
    $scope.getClient();
    $scope.getContact(null);
    $scope.getJobOpeningInfo_byJoiId();





})
