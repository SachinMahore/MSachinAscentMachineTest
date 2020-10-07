var addFilterCriteria = function () {
    var filterText = "";
    var filterValue = "";
    var selectFieldValue = $("#ddlField").val();
    //if (selectFieldValue==0)
    filterText = $("#txtCriteria").val();
    if (filterText != "")
    {
    filterValue = filterText;
    //-----------------------------------------------------//
    var filterType = $("#ddlField").val();
    var filterCriteria = $("#ddlField").val();

    if ($("#divFilterCriteria").find("#divFC_" + filterCriteria).length) {
        $('#lblFT_' + filterCriteria).html(filterType.toUpperCase() + " : " + filterText.toUpperCase());
        $('#lblFT_' + filterCriteria).data("value", filterValue);
    }
    else {
        $("#divFilterCriteria").append("<div id=divFC_" + filterCriteria + " class='form-group clearfix m-0' style='margin:0'><label id='lblFT_" + filterCriteria + "' class='control-label col-sm-11 padding-0' data-value='" + filterValue + "'>" + filterType.toUpperCase() + " : " + filterText.toUpperCase() + "</Label><button id='btnRemove' type='button' class='btn btn-danger pull-right' style='padding: 0px 1px ! important;' onclick='removeFilter(\"" + filterCriteria + "\")'><i class='glyphicon glyphicon-remove-circle' style='margin-top:-3px'></i></button></div>");
    }
    $("#txtCriteria").val("");
    }
    else
    {
        alert("Enter Criteria");
    }
}
var removeFilterAll = function () {
    $("#divFilterCriteria").html("");
}
var removeFilter = function (id) {
    $('#divFC_' + id).remove();
}
var createEmployee = function (id) {
    window.location.href = "/Employee/Create";
}
var getEmployeeList = function (PN) {
    $("#divLoader").show();
    var empname = "";
    var city = "";
   
    if ($("#divFilterCriteria").find("#divFC_EmployeeName").length) {
        empname = $('#lblFT_EmployeeName').data("value");
    }
    if ($("#divFilterCriteria").find("#lblFT_City").length) {
        city = $('#lblFT_City').data("value");
    }

    var rowDisplay = $("#ddlRow").val();

    var empSearchModel = {
        EmployeeName: empname,
        City: city,
        RowDisplay: rowDisplay,
        PageNumber: PN
    };

    $.ajax({
        url: "/Employee/GetEmployeeListData",
        type: "post",
        contentType: "application/json utf-8",
        data: JSON.stringify(empSearchModel),
        datatype: "JSON",
        success: function (response) {
            $("#tblEmployee>tbody").empty();
            $.each(response, function (elementType, elementValue) {
                var html = "<tr>";
                html += "<td>" + elementValue.EmployeeID + "</td>";
                html += "<td>" + elementValue.EmployeeName + "</td>";
                html += "<td>" + elementValue.City + "</td>";
                html += "</tr>";
                $("#tblEmployee>tbody").append(html);
            });
            $("#divLoader").hide();
        }
    });
}
$(document).ready(function () {
    getEmployeeList(1);
    $("#ddlRow").on('change', function (evt, params) {
        var selected = $(this).val();
        if (selected != null) {
            getEmployeeList(1);
        }
    });
});