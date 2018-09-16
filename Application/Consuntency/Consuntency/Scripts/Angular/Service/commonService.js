angular.module("myApp")
.factory('commonService', function () {
    var fa = {};

    //fa.convertDateStringToDateObj = function (dateString) {

    //    var dateParts = dateString.split("-");

    //    return new Date(dateParts[2], dateParts[1] - 1, dateParts[0]); // month is 0-based
    //}
    fa.showErrorPopup = function (errMsg) {

        var div = $("<a href=\"#popup\" id=\"pop\"></a><a href=\"#x\" class=\"overlay\" id=\"popup\"></a><div class=\"popup\"><div id=\"ErrorMes\"></div><a class=\"close\" href=\"#close\"></a></div>");
        $(div).appendTo("body");
        $("#ErrorMes").empty();
        $("#ErrorMes").append(errMsg);

        window.location = "#popup";
    }
    fa.convertDateStringToDateObj = function (dateString) {

        var dateParts = dateString.split("-");

        return new Date(dateParts[2], dateParts[1] - 1, dateParts[0]); // month is 0-based
    }
   fa.getModelAsFormData = function (data) {
        var dataAsFormData = new FormData();
        angular.forEach(data, function (value, key) {
            dataAsFormData.append(key, value);
        });
        console.log(dataAsFormData);
        return dataAsFormData;
   };
   fa.setTimeout_OnDatatable = function () {
       
       setTimeout(function () {
           $('.dataTable').DataTable();
           $('.dataTables_length select').removeClass('custom-select');
       }, 1000)
   }

    return fa;

})
