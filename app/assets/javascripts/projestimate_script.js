$(document).ready(function() {

    $('.tabs').tabs({
        select: function(event, ui) {
            var index_tab = ui.index + 1;
            $(".current_tab").val("tabs-" + index_tab);
        }
    });

    $('html, body').animate({ scrollTop: 0 });

    $('.attribute_tooltip').tooltip({'html' : true });

    $("#run_estimation").bind('click', function() {
        $('.icon-signal').toggle();
        $('.icon-list').toggle();
        $('.icon-align-left').toggle();
        $('.spiner').show();
    });

     $('ul li').hover(
        function () {
          $(this.children).css('display', 'block');
        },
        function () {
         $('.block_link').hide();
        }
      );

    $("#component_work_element_type_id").change(function(){
      if(this.value == "2"){
        $(".link_tabs").show();
      }
      else{
        $(".link_tabs").hide();
      }
    });

    $('#user_record_number').change(
        function(){
            $.ajax({
                    url:"user_record_number",
                    method: 'GET',
                    data: "nb=" + this.value
            })
    });

    $('.input-small').bind("blur",(
        function(){
            $.ajax({
                url:"check_attribute",
                type: 'POST',
//                data: "value=" + this.value + "&level=" + this.className.split(/\s/)[1] + "&est_val_id=" + this.className.split(/\s/)[2]
                data: "value=" + this.value + "&level=" + this.className.split(/\s/)[1] + "&est_val_id=" + $(this).data("est_val_id") + "&wbs_project_elt_id=" + $(this).data("wbs_project_elt_id")
            })
        }
    ));

    $('#states').change(
        function(){
            $.ajax({
                    url:"display_states",
                    method: 'GET',
                    data: "state=" + this.value
            })
    });

    $("#user_id").change(
            function () {
              $.ajax({ url:'/load_security_for_selected_user',
                data:'user_id=' + this.value + '&project_id=' + $('#project_id').val()
              })
            }
    );

    $("#group_id").change(
            function () {
              $.ajax({ url:'/load_security_for_selected_group',
                data:'group_id=' + this.value + '&project_id=' + $('#project_id').val()
              })
            }
    );

    $("#pbs_list").change(
        function(){
            $('.spiner').show();
            $.ajax({
                url:'/selected_pbs_project_element',
                data:'pbs_id=' + this.value + '&project_id=' + $('#project_id').val()
            })
        }
    );

    $( ".tabs" ).tabs({
        beforeLoad: function( event, ui ) {
            ui.jqXHR.error(function() {
                ui.panel.html(
                    "Couldn't load this tab. We'll try to fix this as soon as possible. " +
                        "If this wouldn't be a demo." );
            });
        }
    });

    if(($('.div_tabs_to_disable').data('enable_update')) ==  false){
        $('.div_tabs_to_disable').find('input, textarea, button, select, a').attr('disabled','disabled');
        $('.select_ratio').removeAttr("disabled");
    }

    $(function() {
        $("#users th a, #users .pagination a").on("click", function() {
          $.getScript(this.href);
          return false;
        });
        $("#users_search input").keyup(function() {
          $.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
          return false;
        });
    });


    var hideFlashes = function () {
        $("#notice, #error, #warning, .on_success_global, .on_success_attr, .on_success_attr_set").fadeOut(2000);
    };
    setTimeout(hideFlashes, 5000);

    $(".pemodule").hover(
        function(){
            $(this.children).css('display', 'block');
        },
        function () {
            $('.links').hide();
        }
    );


    //Need to disable or enable the custom_value field according to the record_status value
    $(".record_status").change(function(){
        var status_text = $('select.record_status :selected').text();
        if(status_text == "Custom"){
            $(".custom_value").removeAttr("disabled");
        }
        else{
            $(".custom_value").attr("disabled", true);
        }
    });


    $("#wbs_activity_element_parent_id").change(function(){
        $.ajax({
            url:"/update_status_collection",
            method: 'GET',
            data: "selected_parent_id=" + $('#wbs_activity_element_parent_id').val()
        })
    });

    $("#wbs_activity_element").change(function(){
        $("#add_activity_and_ratio_to_project").attr("disabled", true);
        $.ajax({
            url:"/refresh_wbs_activity_ratios",
            method: 'GET',
            data: "wbs_activity_element_id=" + $('#wbs_activity_element').val()
        })
    });

    $("#project_default_wbs_activity_ratio").change(function(){
       var selection = $('#project_default_wbs_activity_ratio').val();
       if(selection == ""){
           $("#add_activity_and_ratio_to_project").attr("disabled", true);
           //$("#add_activity_and_ratio_to_project").css('color', 'red');
       }
       else{
           $("#add_activity_and_ratio_to_project").removeAttr("disabled");
           //$(".btn").css('background-color', 'blue');
       }
    });

    //ADD selected WBS-Activity to Project
    $("#form_select_and_add_wbs_activity").live("ajax:complete", function(event,xhr,status){
        $('#wbs_activity_element').val('');
        $.ajax({
            url:"/refresh_wbs_project_elements",
            method: 'GET',
            data: {
                elt_id: $('#wbs_activity_element').val(),
                project_id: $('#project_id').val()
            }
        });
        return false;
    });

    //Allow to copy value from one field to another
    $('.copyLib').css('cursor', 'pointer');

    $(".copyLib").click(function(){
        var effort_input_id = "_low"+$(this).data("effort_input_id");
        var first_value = $("#"+effort_input_id).val();

        var low_level =         "_low"+$(this).data("effort_input_id");
        var most_likely_level = "_most_likely"+$(this).data("effort_input_id");
        var high_level =        "_high"+$(this).data("effort_input_id");

        document.getElementById(low_level).value = first_value;
        document.getElementById(most_likely_level).value = first_value;
        document.getElementById(high_level).value = first_value;
        return false;
    });

});

// ################################# Other methods #################################

function show_popup(elem) {
  jQuery('#'+elem).slideDown("fast");
  jQuery(".popup_mask").fadeIn("normal");
}

function hide_popup(elem) {
  jQuery('#'+elem).slideUp("fast");
  jQuery(".popup_mask").fadeOut("normal");
}

function toggle_folder(elem){
    if($(elem).parent().parent().next().is('ul') == true)
        $(elem).parent().parent().next().toggle();
}

function refresh_me(data){
    var show_exclude = false;
    //if($('input:checkbox').is(":checked")) {
    if($('#show_excluded_elt:checkbox').is(":checked")) { show_exclude = true; }
    else{ show_exclude = false; }

    $.ajax({
        url:"/refresh_wbs_project_elements",
        method: 'GET',
        data: {
            project_id: $("#project_id").val(),
            show_hidden: show_exclude,
            dataType: "html"
        }
        ,
        success: function(data) {
            $('#wbs_project_elements_section').html(data.html);
            $('ul li').hover(
                function () {
                    $(this.children).css('display', 'block');
                },
                function () {
                    $('.block_link').hide();
                }
            );
        },
        error: function(XMLHttpRequest, testStatus, errorThrown) { alert('Error!'); }
    });
}




function select_or_unselect_all(clicked_elt){
    var mp_id = $(clicked_elt).data("mp_id");
    var rows_or_cols = $(clicked_elt).data("rows_or_cols");
    var at_least_one_selected = false;
    var number_of_elt = 0;
    var number_of_checked_elt = 0;

    if (rows_or_cols == "cols") {
        $('.module_project_'+mp_id+':checkbox').each(function(){
            number_of_elt = number_of_elt+1;
            //at_least_one_selected = (this.checked ? true : false);
            if (this.checked)
                number_of_checked_elt = number_of_checked_elt+1;
        });

        if (number_of_checked_elt==0 || number_of_checked_elt < number_of_elt)
            $('.module_project_'+mp_id).attr("checked", true);
        else
            $('.module_project_'+mp_id).attr("checked", false);
    }
    else{
        if (rows_or_cols == "rows") {
            $('.pbs_'+mp_id+':checkbox').each(function(){
                number_of_elt = number_of_elt+1;
                if (this.checked)
                    number_of_checked_elt = number_of_checked_elt+1;
            });

            if (number_of_checked_elt==0 || number_of_checked_elt < number_of_elt)
                $('.pbs_'+mp_id).attr("checked", true);
            else
                $('.pbs_'+mp_id).attr("checked", false);
        }
    }
}


jQuery.fn.submitWithAjax = function () {
    this.submit(function () {
        $.post($(this).attr('action'), $(this).serialize(), null, "script");
        return false;
    });
};

