angular.module('myApp').controller('interviewsCtrl', function ($scope, $http, commonService, $filter) {
    $scope.i = {};
    $scope.divInterviews = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
    
    

    $scope.getClient = function (p) {
     

        $http.get('/Client/getClient').then(function (response) {
            console.log(response);
            $scope.listClient = response.data.listClient;
        }, function (error) {
        })
    }
    $scope.getCandidates = function () {
        $http.get('/Candidates/getCandidates').then(function (response) {
            console.log(response);
            $scope.listCandidates = response.data.listCandidates;
             if($('#candidateId').val()>0)
             {
                 $scope.i.candidateId =parseInt($('#candidateId').val());
            }
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
    $scope.getJobOpeningInfo_byClientId = function () {
        $http.get('/JobOpeningInfo/getJobOpeningInfo?clientId=' + $scope.i.clientId).then(function (response) {
            console.log(response);
            $scope.listJobOpeningInfo = response.data.listJobOpeningInfo;
            angular.forEach($scope.listJobOpeningInfo, function (element, index) {
                element.targetDT = $filter('date')(element.targetDT.slice(6, -2), 'dd-MM-yyyy');
                //element.openedDT = $filter('date')(element.openedDT.slice(6, -2), 'dd-MM-yyyy');
            })
            
        }, function (error) {
        })
    }

    $scope.getClient_AccountManager_byClientId = function () {
        $http.get('/Interviews/getClient_AccountManager_byClientId?clientId=' + $scope.i.clientId).then(function (response) {
            console.log(response);
            $scope.listAM = response.data.listAM;
            
        }, function (error) {
        })
    }
    $scope.getInterviewName = function () {
        $http.get('/Interviews/getInterviewName').then(function (response) {
            console.log(response);
            $scope.listIM = response.data.listIM;

        }, function (error) {
        })
    }




    $scope.saveInterviews = function (p) {
        debugger;
        var x = $('#formInterviews');
        var status = $(x).ValidationFunction();
        if (status == false) {
            return false;
        }
        debugger;
        $scope.btnSave = 0;
        var i_copy = {};
        i_copy = angular.copy($scope.i);
        if (i_copy.toDate != undefined && i_copy.toDate != null && i_copy.toDate != '') {
            i_copy.toDate = commonService.convertDateStringToDateObj(i_copy.toDate);
        }
        $http.post('/Interviews/saveInterviews', { i: i_copy }).then(function (response) {
            console.log(response);
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            if (response.data.msg == 's') {
                var others;
                debugger;
                //if (window.FormData !== undefined) {
                var fileData = new FormData();
                if ($("#others_Photo_Doc").val() != '') {
                    fileData.append($("#others_Photo_Doc").get(0).files[0].name, $("#others_Photo_Doc").get(0).files[0]);
                    others = "yes";
                    $http({
                        url: '/Interviews/saveInterviewsPhoto_Doc?others=' + others + '&interviewId=' + response.data.interviewId,
                        method: 'POST',
                        data: fileData,
                        headers: { 'Content-Type': undefined },
                        transformRequest: angular.identity
                    }).then(function (resPhoto) {
                        console.log(resPhoto);
                        if (resPhoto.data.msg == 's') {
                            showSuccessToast("Saved Successfully.");
                            $scope.getInterviews();
                            $scope.clear();
                            $scope.btnSave = 1;
                            if (p == 'n') {
                                $scope.divInterviews = 0;
                                $scope.i.candidateId = parseInt($('#candidateId').val());
                            }
                            else {
                                $scope.divInterviews = 1;
                                if ($('#candidateId').val() > 0) {
                                    window.location = '/Candidates/showCandidateInfo?candidateId=' + $('#candidateId').val();
                                }
                            }
                        }
                        $("#others_Photo_Doc").val('');
                    }, function (errorPhoto) {
                        $("#others_Photo_Doc").val();
                        $scope.btnSave = 1;

                    })
                }

                    //}
                else {
                    showSuccessToast("Saved Successfully.");
                    $scope.getInterviews();
                    $scope.clear();
                    $scope.btnSave = 1;

                    if (p == 'n') {
                        $scope.divInterviews = 0;
                        $scope.i.candidateId = parseInt($('#candidateId').val());
                    }
                    else {
                        $scope.divInterviews = 1;
                        if ($('#candidateId').val() > 0) {
                            window.location = '/Candidates/showCandidateInfo?candidateId=' + $('#candidateId').val();
                        }
                    }
                }
            }
            else {
                showNoticeToast("Failed!Try Again.");
                $scope.getInterviews();
                $scope.clear();
                $scope.btnSave = 1;
            }
        }, function (error) {
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.getInterviews();
            $scope.btnSave = 1;
        })
    }


    $scope.getInterviews = function () {
        $http.get('/Interviews/getInterviews').then(function (response) {
            console.log(response);
            $scope.listInterviews = response.data.listInterviews;
            angular.forEach($scope.listInterviews, function (element, index) {
                element.toDate = $filter('date')(element.toDate.slice(6, -2), 'dd-MM-yyyy');
            })
            commonService.setTimeout_OnDatatable();
        }, function (error) {
        })
    }

    $scope.clear = function () {
        $scope.i = {};
    }
    $scope.cancel = function () {
        $scope.clear();
        $('input,select').removeClass('error');
        if ($('#candidateId').val() > 0) {
            window.location = '/Candidates/showCandidateInfo?candidateId=' + $('#candidateId').val();
        }
        else {
            $scope.divInterviews = 1;
        }
    }
    $scope.allChkboxChecked_UnChecked = function () {
        angular.forEach($scope.listInterviews, function (element, index) {
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
        angular.forEach($scope.listInterviews, function (element, index) {

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
    $scope.deleteInterviews = function () {
        var Ids = '';
        angular.forEach($scope.listInterviews, function (element, index) {

            if (element.chkbox == true) {
                
                Ids += element.interviewId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            console.log(Ids);
            $http.post('/Interviews/deleteInterviews', { interviewIds: Ids }).then(function (response) {
                console.log(response);
                $scope.getInterviews();
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                if (response.data.msg == 's') {
                    showSuccessToast("Delete Successfully.");

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
    $scope.editInterviews = function () {
        $scope.cr_al = '';
        //$scope.j = angular.copy(this.jo);
        angular.forEach($scope.listInterviews, function (element, index) {

            if (element.chkbox == true) {
                $scope.i = angular.copy(element);
                $scope.getJobOpeningInfo_byClientId();
                $scope.getClient_AccountManager_byClientId();
                return false;
            }

        })
        $scope.divInterviews = 0;
        

    }
    //var others_Photo_Doc = "";

    //$('#others_Photo_Doc').on('change', function () {
    //    others = $(this).val();
    //    var ext = others_Photo_Doc.split('.').pop();
    //    if (ext == "pdf" || ext == "docx" || ext == "doc") {

    //    } else {
    //        $('#others_Photo_Doc').val('');
    //        alert("Please Select Only Pdf and Document");

    //    }
    //});
    $scope.getClient();
    $scope.getCandidates();
    $scope.getInterviewName();
    $scope.getInterviews();
    if ($('#candidateId').val() > 0) {
        $scope.divInterviews = 0;
        $scope.i.candidateId =parseInt($('#candidateId').val());

    }

})