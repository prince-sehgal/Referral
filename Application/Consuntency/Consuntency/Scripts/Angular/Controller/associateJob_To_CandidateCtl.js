angular.module('myApp').controller('associateJob_To_CandidateCtl', function ($scope, $http, commonService, $filter) {
    var _ass = $('#ass').val();
    //var joiId;
    //joiId = $('#joiId').val();
    //$scope.j = {};
    //$scope.getJobOpeningInfo_byJoiId = function () {
    //    $http.get('/JobOpeningInfo/getJobOpeningInfo_byJoiId?joiId=' +joiId).then(function (response) {
    //        console.log(response);
    //        $scope.j = response.data.j;
    //        if ($scope.j.targetDT != null && $scope.j.targetDT != undefined && $scope.j.targetDT != '') {
    //            $scope.j.targetDT = $filter('date')($scope.j.targetDT.slice(6, -2), 'dd-MM-yyyy');
    //        }
    //        if ($scope.j.openedDT != null && $scope.j.openedDT != undefined && $scope.j.openedDT != '')
    //        {
    //            $scope.j.openedDT = $filter('date')($scope.j.openedDT.slice(6, -2), 'dd-MM-yyyy');
    //        }
    //    }, function (error) {
    //    })
    //}
    $scope.t = true;

    $scope.getJobOpeningInfo_Not_AlreadyTag_OnSameCandidate = function () {
        $http.get('/AssociateJobToCandidate/getJobOpeningInfo_Not_AlreadyTag_OnSameCandidate?clientId=' + $scope.clientId+'&candidateIds='+ $('#candidateIds').val()).then(function (response) {
            console.log(response);
            $scope.listJobOpeningInfo = response.data.listJobOpeningInfo;
            angular.forEach($scope.listJobOpeningInfo, function (element, index) {
                element.targetDT = $filter('date')(element.targetDT.slice(6, -2), 'dd-MM-yyyy');
                //element.openedDT = $filter('date')(element.openedDT.slice(6, -2), 'dd-MM-yyyy');
            })
        }, function (error) {
        })
    }
    
    var cIds;
    var joiIds;
    var listJoiIds = [];
    var listCandidateIds=[];
  $scope.saveAssociateJob_To_Candidate = function () {
      $scope.btnSave = 0;
      if (_ass == 'j') {
          cIds = $('#candidateIds').val();
           listCandidateIds = cIds.split(',');
          angular.forEach($scope.listJobOpeningInfo, function (element, index) {
              if (element.chkbox_forAssJoi == true) {
                  listJoiIds.push(element.joiId);
              }

          })
      }
      else if (_ass == 'c')
      {
          joiIds = $('#joiIds').val();
          //alert(joiIds);
          listJoiIds = joiIds.split(',');
          angular.forEach($scope.listCandidates, function (element, index) {
              if (element.chkbox_forAssCandidate == true) {
                  listCandidateIds.push(element.cId);
              }

          })
      }
        //if (listJoiIds.length > 0)
        //{
            $http.post('/AssociateJobToCandidate/saveAssociateJob_To_Candidate', { listCandidateIds: listCandidateIds, listJoiIds: listJoiIds, comments: $scope.comments, csSubCatId: $scope.csSubCatId }).then(function (response) {
                console.log(response);
                if (response.data.msg == 's') {
                    showSuccessToast("Saved Successfully.");
                    window.location = "/JobOpeningInfo/JobOpeningInfo";
                }
                else {
                    showSuccessToast("Failed! Try Again.");
                }
            }, function (error) {
            })

        //}
        
    }
    $scope.joiId = 0;
    $scope.btnSave = 0;
    $scope.allChkboxChecked_UnChecked_forJoi = function () {
        var i = 0;
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {
            if ($scope.chkboxHeader_forAssJoi == true) {
                element.chkbox_forAssJoi = true;
                i++;
            }
            else if ($scope.chkboxHeader_forAssJoi == false) {
                element.chkbox_forAssJoi = false;
            }
        })
        $scope.set_btnSave_Enable_forAssJoi();
    }
    $scope.getClient = function () {

        $http.get('/Client/getClient').then(function (response) {
            console.log(response);
            $scope.listClient = response.data.listClient;

        }, function (error) {
        })
    }
    $scope.getCandidateStatusCat_SubCat = function () {
        $http.get('/Candidates/getCandidateStatusCat_SubCat').then(function (response) {
            console.log(response);
            $scope.listCSCat_SubCat = response.data.listCSCat_SubCat;
            angular.forEach($scope.listCSCat_SubCat, function (element, index) {
                if (element.csSubCat == "Associated") {
                    $scope.csSubCatId = element.csSubCatId;
                    return false;
                }


            })
        }, function (error) {
        })
    }
    $scope.set_btnSave_Enable_forAssJoi = function () {
        var i = 0;
        angular.forEach($scope.listJobOpeningInfo, function (element, index) {

            if (element.chkbox_forAssJoi == true) {
                i = i + 1;
            }

        })
        if (i > 0) {
            $scope.btnSave = 1;
        }

        else {
            $scope.btnSave = 0;
        }
    }


    $scope.getCandidates_Not_AlreadyTag_OnSamePosition = function () {
        $http.get('/AssociateJobToCandidate/getCandidates_Not_AlreadyTag_OnSamePosition?joiId=' + $('#joiIds').val()).then(function (response) {
            console.log(response);
            $scope.listCandidates = response.data.listCandidates;

        }, function (error) {
        })
    }

    $scope.allChkboxChecked_UnChecked_forAssCandidate = function () {
        var i = 0;
        angular.forEach($scope.listCandidates, function (element, index) {
            if ($scope.chkboxHeader_forAssCandidate == true) {
                element.chkbox_forAssCandidate = true;
                i++;
            }
            else if ($scope.chkboxHeader_forAssCandidate == false) {
                element.chkbox_forAssCandidate = false;
            }
        })
        $scope.set_btnSave_Enable_forAssCandidate();
    }

    $scope.set_btnSave_Enable_forAssCandidate = function () {
       
        var i = 0;
        angular.forEach($scope.listCandidates, function (element, index) {

            if (element.chkbox_forAssCandidate == true) {
                i = i + 1;
            }

        })
        debugger;
        if (i > 0) {
            $scope.btnSave = 1;
        }

        else {
            $scope.btnSave = 0;
        }
    }
    $scope.showModalAssJobOPening = function () {
        $('#ModalAssJobOPening').modal('show');
    }

    //$scope.getJobOpeningInfo_byJoiId();
    $scope.getClient();
    $scope.getCandidateStatusCat_SubCat();
    $scope.getCandidates_Not_AlreadyTag_OnSamePosition();
    

})