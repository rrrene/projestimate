var warnLeavingUnsavedMessage;

function warn_me(message){
    warnLeavingUnsavedMessage = message;
    $('.simple_form').submit(function(){
        $('textarea').not("table.tablesorterPager textarea").removeData('changed');
        $('input').not("table.tablesorterPager input").removeData('changed');
//        $('select').removeData('changed');
    });
    $('textarea').not("table.tablesorterPager textarea").change(function(){
        $(this).data('changed', 'changed');
    });
    $('input').not("table.tablesorterPager input").change(function(){
        $(this).data('changed', 'changed');
    });
//    $('select').change(function(){
//        $(this).data('changed', 'changed');
//    });
    window.onbeforeunload = function(){
        var warn = false;
        $('textarea').not("table.tablesorterPager textarea").blur().each(function(){
            if ($(this).data('changed')) {
                warn = true;
            }
        });
        $('input').not("table.tablesorterPager input").blur().each(function(){
            if ($(this).data('changed')) {
                warn = true;
            }
        });
//        $('select').blur().each(function(){
//            if ($(this).data('changed')) {
//                warn = true;
//            }
//        });

        if (warn) {return warnLeavingUnsavedMessage;}
    }
}