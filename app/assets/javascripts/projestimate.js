function generate_tr_filter(value){
    $('#' + value + '_id').show();
}

function toggle_folder(elem){
    $(elem).parent().parent().next().toggle();
}