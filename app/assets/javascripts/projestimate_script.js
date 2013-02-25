$(document).ready(function() {

    $("#project_security_level").change(
            function () {
              $.ajax({ url:'/update_project_security_level',
                data:'project_security_level=' + this.value + '&user_id=' + $("#user_id").val()
              })
            }
    );

    $("#project_security_level_group").change(
            function () {
              $.ajax({ url:'/update_project_security_level_group',
                data:'project_security_level=' + this.value + '&group_id=' + $("#group_id").val()
              })
            }
    );

    $('#project_area').change(
      function(){
        $.ajax({url: '/select_categories',
               data: 'project_area_selected=' + this.value
        })
      });

      $('#select_integrated_module').change(function(){
        $.ajax({url: '/add_your_integrated_module',
                method: 'get',
               data: 'module_selected=' + this.value
        })
      });

     $('.component_tree > ul li').hover(
        function () {
          $(this.children).css('display', 'inline');
        },
        function () {
         $('.block_link').hide();
        }
      );

    $("#jump_project_id").change(function(){
        $.ajax({
            url:"change_selected_project",
            method: 'get',
            data: "project_id=" + this.value,
            success: function(data) {
              document.location.href="dashboard"
              }
            });
    });

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

    $('#project_record_number').change(
        function(){
            $.ajax({
                    url:"project_record_number",
                    method: 'GET',
                    data: "nb=" + this.value
            })
    });


    $('#states').change(
        function(){
            $.ajax({
                    url:"display_states",
                    method: 'GET',
                    data: "state=" + this.value
            })
    });

    $(".select_ratio").change(
        function(){
            $.ajax({
                    url:"/refresh_ratio_elements",
                    method: 'GET',
                    data: "wbs_activity_ratio_id=" + this.value
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

      $('#select_module').change(function(){
        $.ajax({url: '/add_module',
                method: 'get',
                data: 'module_selected=' + this.value + '&project_id=' + $('#project_id').val()
        })
      });


    $( ".tabs" ).tabs();


    $(function() {
        $("#users th a, #users .pagination a").live("click", function() {
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

    $('.component_tree ul li').hover(
        function () {
          $(this.children).css('display', 'block');
        },
        function () {
         $('.block_link').hide();
        }
      );

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


//    //checkbox.attr("value")
//    //$("#show_excluded_elt").click(function(){
//    $("#show_excluded_elt").live('click', (function(){
//    //$('#show_excluded_elt').bind('click', function() {
//
//        show_exclude = $("#show_excluded_elt").value();
//        alert("Test");
//        return false;
////        $.ajax({
////            url:"/refresh_wbs_project_elements",
////            method: 'GET',
////            data: {
////                project_id: $("#project_id").val(),
////                show_hidden: show_exclude
////            }
////        });
//    }));


    //Disable all elements in DIV
    $.fn.disable = function() {
        return this.each(function() {
            if (typeof this.disabled != "undefined") {
                $(this).data('jquery.disabled', this.disabled);

                this.disabled = true;
            }
        });
    };

    $.fn.enable = function() {
        return this.each(function() {
            if (typeof this.disabled != "undefined") {
                this.disabled = $(this).data('jquery.disabled');
            }
        });
    };

    test = $('#tabs-1-group').data('enable_update');
    if(test == false){
        $('#tabs-1-group *').disable();
    }
    //END disabled all elements in DIV


}); //END Document.ready



function show_popup(elem) {
  jQuery('#'+elem).slideDown("fast");
  jQuery(".popup_mask").fadeIn("normal");
}

function hide_popup(elem) {
  jQuery('#'+elem).slideUp("fast");
  jQuery(".popup_mask").fadeOut("normal");
}

function toggle_folder(elem){
    $(elem).parent().parent().next().toggle();
}

//var val = $('#show_excluded_elt:checked').attr('checked');
//$('input:checkbox').change(function(){
function refresh_me(){
    show_exclude = false;
    if($('input:checkbox').is(":checked")) {
        show_exclude = true;
        //$("#wbs_project_elements_section").hide();
    }
    else{
        show_exclude = false;
    }

    $.ajax({
        url:"/refresh_wbs_project_elements",
        method: 'GET',
        data: {
            project_id: $("#project_id").val(),
            show_hidden: show_exclude
        }
    });
}


