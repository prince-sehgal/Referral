angular.module('myApp').controller('candidatesCtrl', function ($scope, $http, commonService, $filter) {

    $scope.divCandidate = 1;
    $scope.btnEdit = 0;
    $scope.btnDelete = 0;
    $scope.btnSave = 1;
    $scope.btnNew = 1;
    $scope.c={};
    $scope.c.recruiterId = 0;
    $scope.c.sourceId = 0;

    $scope.getQualification = function () {
        $http.get('/Candidates/getQualification').then(function (response) {
            //console.log(response);
            $scope.listQualification = response.data.listQualification;
        }, function (error) {
        })
    }
    $scope.getCandidateStatusCat_SubCat = function () {
        $http.get('/Candidates/getCandidateStatusCat_SubCat').then(function (response) {
            //console.log(response);
            $scope.listCSCat_SubCat = response.data.listCSCat_SubCat;

            //for associate job opening
            $scope.listCSCat_SubCat_forAssJO = response.data.listCSCat_SubCat;
            angular.forEach($scope.listCSCat_SubCat_forAssJO, function (element, index) {
                if(element.csSubCat=="Associated")
                {
                    $scope.csSubCatId = element.csSubCatId;
                    return false;
                }


            })
        }, function (error) {
        })
    }
    $scope.getSource = function () {
        $http.get('/Candidates/getSource').then(function (response) {
            //console.log(response);
            $scope.listSource = response.data.listSource;
        }, function (error) {
        })
    }
    $scope.getRecruiter = function () {
        $http.get('/Candidates/getRecruiter').then(function (response) {
            //console.log(response);
            $scope.listRecruiter = response.data.listRecruiter;
        }, function (error) {
        })
    }


    $scope.saveCandidates = function (p) {
        var errMsg = '';
        var x = $('#formCandidates');
        var status = $(x).ValidationFunction();

        if (status == false) {
            return false;
        }
        $http.post('/Candidates/check_Candidate_Exists_EmailId_MobileNo', { c: $scope.c }).then(function (response) {
            //console.log(response);
            //console.log(errMsg);

            if (response.data.emailStatus == 1 || response.data.mobileStatus == 1) {
                if (response.data.emailStatus == 1 && response.data.mobileStatus == 1) {
                    errMsg = '';
                    errMsg+="<p>EmailID Is already Exists! Please Enter Another EmailID</p>";
                    errMsg+="<p>Mobile Number Is already Exists! Please Enter Another Mobile Number</p>";
                    commonService.showErrorPopup(errMsg);
                }
                else if (response.data.emailStatus == 1 && response.data.mobileStatus == 0) {
                    errMsg = "<p>EmailID Is already Exists! Please Enter Another EmailID</p>";

                 commonService.showErrorPopup(errMsg);
                }
                else  if(response.data.mobileStatus == 0 && response.data.mobileStatus == 1)
                {
                    errMsg = "<p>Mobile Number Is already Exists! Please Enter Another Mobile Number</p>";
                 commonService.showErrorPopup(errMsg);
                }
                return false;
            }
            else {
        $scope.btnSave = 0;
        $http.post('/Candidates/saveCandidates', { c: $scope.c, listEduDetail: $scope.listEduDetail, listExpDetail: $scope.listExpDetail }).then(function (response) {
            //console.log(response);
            if (response.data.msg == 's') {
                $scope.c.recruiterId = 0;
                $scope.c.sourceId = 0;
                $scope.chkboxHeader = false;
                $scope.allChkboxChecked_UnChecked();
                var rs = '';
                var ot = '';
                
                var fileData = new FormData();
                if ($("#resume").val() != '' || $("#others").val() != '') {
                    if ($("#resume").val() != '') {
                        fileData.append($("#resume").get(0).files[0].name, $("#resume").get(0).files[0]);
                       rs = "yes";
                    }
                    if ($("#others").val() != '') {
                        fileData.append($("#others").get(0).files[0].name, $("#others").get(0).files[0]);
                       ot = "yes";
                    }
                    $http({
                        url: '/Candidates/saveCandidatesPhoto_Doc?rs=' + rs +'&ot='+ot+'&cId=' + response.data.cId,
                        method: 'POST',
                        data: fileData,
                        headers: { 'Content-Type': undefined },
                        transformRequest: angular.identity
                    }).then(function (resPhoto) {
                        //console.log(resPhoto);
                        //console.log(response);
                        if (resPhoto.data.msg == 's') {
                            showSuccessToast("Saved Successfully.");
                            $scope.getCandidates();
                            $scope.clear();
                            $scope.btnSave = 1;
                            if (p == 'n') {
                                $scope.divCandidate = 0;
                            }
                            else {
                                $scope.divCandidate = 1;
                            }
                        }
                        $("#resume").val('');
                        $("#others").val('');
                    }, function (errorPhoto) {
                        $("#resume").val('');
                        $("#others").val('');
                        $scope.btnSave = 1;

                    })
                }

                    //}
                else {
                    showSuccessToast("Saved Successfully.");
                    $scope.getCandidates();
                    $scope.clear();
                    $scope.btnSave = 1;

                    if (p == 'n') {
                        $scope.divCandidate = 0;
                    }
                    else {
                        $scope.divCandidate = 1;
                    }
                }
            }
            else {
                showNoticeToast("Failed!Try Again.");
                $scope.getCandidates();
                $scope.clear();
                $("#resume").val('');
                $("#others").val('');
                $scope.btnSave = 1;
            }
        }, function (error) {
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.btnSave = 1;
            $("#resume").val('');
            $("#others").val('');
        })
            }
        }, function (error) {
            $scope.chkboxHeader = false;
            $scope.allChkboxChecked_UnChecked();
            $scope.btnSave = 1;
        })
    }
    $scope.getCandidates = function () {
        $http.get('/Candidates/getCandidates').then(function (response) {
            //console.log(response);
            $scope.listCandidates = response.data.listCandidates;
            commonService.setTimeout_OnDatatable();
        }, function (error) {
        })
    }


    $scope.clear = function () {
        $scope.c = {};
        $scope.listEduDetail = [];
        $scope.listExpDetail = [];
    }
    $scope.divShowHide = function (p) {
        $scope.divCandidate = p;
    }
    $scope.editCandidates = function () {
        //$scope.j = angular.copy(this.jo);
        angular.forEach($scope.listCandidates, function (element, index) {

            if (element.chkbox == true) {
                $scope.c = angular.copy(element);
                return false;
            }

        })
        $scope.divCandidate = 0;
        $http.get('/Candidates/getEducationDetails_And_ExperienceDetails_byCId?cId='+$scope.c.cId).then(function (response) {
            //console.log(response);
            $scope.listEduDetail = response.data.listEduDetail;
            $scope.listExpDetail = response.data.listExpDetail;

        }, function (error) {
        })
    }
    $scope.deleteCandidates = function () {
        var Ids = '';
        angular.forEach($scope.listCandidates, function (element, index) {

            if (element.chkbox == true) {
                //console.log(Ids);
                Ids += element.cId + ',';
            }
        })
        if (Ids.length != 0) {

            Ids = Ids.slice(0, -1);
            //console.log(Ids);
            $http.post('/Candidates/deleteCandidates', { cIds: Ids }).then(function (response) {
                //console.log(response);
                $scope.btnDelete = 1;
                $scope.getCandidates();
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
        angular.forEach($scope.listCandidates, function (element, index) {
            if ($scope.chkboxHeader == true) {
                element.chkbox = true;
            }
            else if ($scope.chkboxHeader == false) {
                element.chkbox = false;
            }
        })
        $scope.checkEditDelete();
    }
    var ed = {};
    ed.institute = '';
    ed.departmant = '';
    ed.degree = '';
    ed.fromMonth = '';
    ed.toMonth = '';
    ed.fromYear = '';
    ed.toYear = '';
    ed.currentlyPursuing = false;;
    $scope.listEduDetail = [];
    $scope.addInListEduDetails = function () {
        $scope.listEduDetail.push(ed);
        ed = {};
        //console.log($scope.listEduDetail);
    }
    var ex = {};
    ex.occupation = '';
    ex.company = '';
    ex.summery = '';
    ex.currentlyWork = false;
    ex.fromMonth = '';
    ex.toMonth = '';
    ex.fromYear = '';
    ex.toYear = '';
    $scope.listExpDetail = [];
    $scope.addInListExpDetails = function () {
        $scope.listExpDetail.push(ex);
        ex = {};
        //console.log($scope.listExpDetail);
    }
    $scope.createYear = function () {
        var date = new Date();
        var currentYear = date.getFullYear();
        $scope.listYear = [];
        var year = 2000;
        for(var i=1;i<=100;i++)
        {
            if (currentYear == year)
            {
                return false;
            }
            year = parseInt(year + 1);
        
            $scope.listYear.push(year);
        }
        //console.log($scope.listYear);

    }
    $scope.createMonth = function () {
        $scope.listMonth = [];
        $scope.listMonth.push("Jan");
        $scope.listMonth.push("Feb");
        $scope.listMonth.push("Mar");
        $scope.listMonth.push("Apr");
        $scope.listMonth.push("May");
        $scope.listMonth.push("June");
        $scope.listMonth.push("July");
        $scope.listMonth.push("Aug");
        $scope.listMonth.push("Sept");
        $scope.listMonth.push("Oct");
        $scope.listMonth.push("Nov");
        $scope.listMonth.push("Dec");
        
        //console.log($scope.listMonth);


    }
    $scope.checkEditDelete = function () {
        var i = 0;
        angular.forEach($scope.listCandidates, function (element, index) {

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
        $scope.divCandidate = 0;
    }
    $scope.deleteEducationDetails = function (index,eduId) {
        $scope.listEduDetail.splice(index,1);
        if (angular.isDefined(eduId)) {
            $http.get('/Candidates/deleteEducationDetails?eduId=' + eduId).then(function (response) {
                //console.log(response);
                $scope.getCandidates();
            }, function (error) {
            })
        }
        $scope.getCandidates();
    }
    $scope.deleteExperienceDetails = function (index, expId) {
        $scope.listExpDetail.splice(index, 1);
        if (angular.isDefined(eduId)) {
            $http.get('/Candidates/deleteExperienceDetails?expId=' + expId).then(function (response) {
                //console.log(response);
                $scope.getCandidates();
            }, function (error) {
            })
        }
        $scope.getCandidates();
    }
    $scope.getClient = function () {
        
        $http.get('/Client/getClient').then(function (response) {
            //console.log(response);
            $scope.listClient = response.data.listClient;

        }, function (error) {
        })
    }
    $scope.getJobOpeningInfo = function () {
        $http.get('/JobOpeningInfo/getJobOpeningInfo?clientId='+$scope.clientId).then(function (response) {
            //console.log(response);
            $scope.listJobOpeningInfo = response.data.listJobOpeningInfo;
            angular.forEach($scope.listJobOpeningInfo, function (element, index) {
                if (element.targetDT != null && element.targetDT != undefined && element.targetDT != '') {
                    element.targetDT = $filter('date')(element.targetDT.slice(6, -2), 'dd-MM-yyyy');
                }
                if (element.openedDT != null && element.openedDT != undefined && element.openedDT != '') {
                    element.openedDT = $filter('date')(element.openedDT.slice(6, -2), 'dd-MM-yyyy');
                }
            })
        }, function (error) {
        })
    }
    $scope.sendCandidatesIds_To_associateJobOpening = function () {
        var candidateIds='';
        angular.forEach($scope.listCandidates, function (element, index) {

            if (element.chkbox == true) {
                candidateIds += element.cId + ',';
            }
        })
        if (candidateIds.length != 0) {
            candidateIds = candidateIds.slice(0,-1);
            window.location = "/AssociateJobToCandidate/associateJobOpening?candidateIds=" + candidateIds+'&ass=j';

        }

    }
    $scope.sendCandidatesIds_To_sendEmail = function () {
        var candidateIds = '';
        angular.forEach($scope.listCandidates, function (element, index) {

            if (element.chkbox == true) {
                candidateIds += element.cId + ',';
            }
        })
        if (candidateIds.length != 0) {
            candidateIds = candidateIds.slice(0, -1);
            window.location = "/SendEmail/sendEmail?candidateIds=" + candidateIds;

        }

    }
    
    $scope.updateCandidateStatus = function () {
        var cIds;
        cIds = $('#candidateIds').val();
        alert(cIds);
        $http.post('/Candidates/updateCandidateStatus', {candidateIds:cIds, joiId: $scope.joiId, comments: $scope.comments, csSubCatId:$scope.csSubCatId }).then(function (response) {
            //console.log(response);
            if (response.data.msg == 's') {
                showSuccessToast("Saved Successfully.");
                window.location = "/Candidates/candidates";
            }
            else {
                showSuccessToast("Failed! Try Again.");
            }
        }, function (error) {
        })
    }
    $scope.joiId = 0;
    $scope.allChkboxChecked_UnChecked_forJoi = function () {
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {
            if ($scope.chkboxHeader_forAssJoi == true) {
                element.chkbox_forAssJoi = true;
            }
            else if ($scope.chkboxHeader_forAssJoi == false) {
                element.chkbox_forAssJoi = false;
            }
        })
        $scope.setJoiId();
    }
    $scope.setJoiId = function () {
        var i = 0;
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {

            if (element.chkbox_forAssJoi == true) {
                i = i + 1;
            }

        })
        if(i==1)
        {
            angular.forEach($scope.listJobOpeningInfo, function (element, index) {

                if (element.chkbox_forAssJoi == true) {
                    $scope.joiId = element.joiId;
                }

            })

        }
        else {
            $scope.joiId = 0;
        }
       
    }
    $scope.cancel = function () {
        //location.reload();
        $scope.clear();
        $('input,select').removeClass('error');
        $scope.divCandidate = 1;
        

    }
    $scope.getAssociateJob_To_Candidate_byCandidateId = function (candidateId) {
        $http.get('/AssociateJobToCandidate/getAssociateJob_To_Candidate_byCandidateId?candidateId=' + candidateId).then(function (response) {
            //console.log(response);
            $scope.listAJC = response.data.listAJC;
          
        }, function (error) {
        })
    }
    $scope.showModalAssociateJob_To_Candidate = function (candidateId) {
        $('#ModalAssociateJob_To_Candidate').modal('show');
        $scope.getAssociateJob_To_Candidate_byCandidateId(candidateId);

    }
    var candidateId=$('#candidateId').val();
    $scope.getCandidates_byCandidateId = function () {
        if (candidateId != undefined) {

            $http.get('/Candidates/getCandidates_byCandidateId?candidateId=' + candidateId).then(function (response) {
                //console.log("hello");
                //console.log(response);
                $scope.c = response.data.c;

                $http.get('/Candidates/getEducationDetails_And_ExperienceDetails_byCId?cId=' + $scope.c.cId).then(function (response) {
                    //console.log(response);
                    $scope.listEduDetail = response.data.listEduDetail;
                    $scope.listExpDetail = response.data.listExpDetail;

                }, function (error) {
                })
            }, function (error) {
            })
        }
    }
    $scope.uploadResume = function () {

        var fileData = new FormData();
        var rs;
        var ot="no";
        if ($("#resume_single").val() != '') {
            if ($("#resume_single").val() != '') {
                fileData.append($("#resume_single").get(0).files[0].name, $("#resume_single").get(0).files[0]);
                rs = "yes";
            }
            $http({
                url: '/Candidates/saveCandidatesPhoto_Doc?rs=' + rs + '&ot=' + ot + '&cId=' + $scope.c.cId,
                method: 'POST',
                data: fileData,
                headers: { 'Content-Type': undefined },
                transformRequest: angular.identity
            }).then(function (resPhoto) {
                //console.log(resPhoto);
                if (resPhoto.data.msg == 's') {
                    showSuccessToast("Upload Successfully.");
                    $scope.getCandidates_byCandidateId();

                    //if (p == 'n') {
                    //    $scope.divCandidate = 0;
                    //}
                    //else {
                    //    $scope.divCandidate = 1;
                    //}
                }

            }, function (errorPhoto) {



            })
        }

    }
    $scope.sendCandidateId_To_showCandidateInfo = function (candidateId) {
        window.location = "/getCandidates_byCandidateId?candidateId="+candidateId;

    }
    $scope.showModalChangeStatus = function () {

        $('#ModalChangeStatus').modal('show');
    }
    $scope.updateCandidateStatus = function () {
        $http.post('/Candidates/updateCandidateStatus', { c: $scope.c }).then(function (response) {
            if (response.data.msg == 's') {
                showSuccessToast("Update Successfully.");
                $scope.hideModalChangeStatus();
                $scope.getCandidates_byCandidateId();
            }

            else {
                showNoticeToast("Failed!Try Again.");
                $scope.hideModalChangeStatus();
            }
        }, function (error) {
            //console.log(error);

        })
    }
    $scope.hideModalChangeStatus = function () {
        $('#ModalChangeStatus').modal('hide');
    }
    $scope.getInterviews_byCandidateId = function () {
        if (candidateId != undefined) {
            $http.get('/Candidates/getInterviews_byCandidateId?candidateId=' + candidateId).then(function (response) {
                //console.log(response);
                $scope.listInterviews = response.data.listInterviews;
                angular.forEach($scope.listInterviews, function (element, index) {
                    if (element.toDate != null) {
                        element.toDate = $filter('date')(element.toDate.slice(6, -2), 'dd-MM-yyyy');
                    }
                })
            }, function (error) {
            })
        }
    }
    //var resume = "";



    //$('#resume').on('change', function () {
    //    resume = $(this).val();
    //    var ext = resume.split('.').pop();
    //    if (ext == "pdf" || ext == "docx" || ext == "doc") {

    //    } else {
    //        $('#resume').val('');
    //        alert("Please Select Only Pdf and Document");

    //    }
    //});
    //var others = "";

    //$('#others').on('change', function () {
    //    others = $(this).val();
    //    var ext = others.split('.').pop();
    //    if (ext == "pdf" || ext == "docx" || ext == "doc") {

    //    } else {
    //        $('#others').val('');
    //        alert("Please Select Only Pdf and Document");

    //    }
    //});
    //var resume_single = "";

    //$('#resume_single').on('change', function () {
    //    others = $(this).val();
    //    var ext = resume_single.split('.').pop();
    //    if (ext == "pdf" || ext == "docx" || ext == "doc") {

    //    } else {
    //        $('#resume_single').val('');
    //        alert("Please Select Only Pdf and Document");

    //    }
    //});

    $scope.createYear();
    $scope.createMonth();
    $scope.getQualification();
    $scope.getSource();
    $scope.getRecruiter();
    $scope.getCandidateStatusCat_SubCat();
    $scope.getCandidates();
    $scope.getClient();
    $scope.getCandidates_byCandidateId();
    $scope.getInterviews_byCandidateId();
  
})