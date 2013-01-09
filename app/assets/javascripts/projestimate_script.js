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
                    data: "nb=" + this.value,
            })
    });

    $('#project_record_number').change(
        function(){
            $.ajax({
                    url:"project_record_number",
                    method: 'GET',
                    data: "nb=" + this.value,
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


});

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




