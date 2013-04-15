////function warn_me(){
//window.onbeforeunload = function(){
//    var inputs = new Array();
//
//    inputs = $(".simple_form input");
//
//    var unfinished = 'false';
//    for (var i=0; i<inputs.length; ++i) {
//        if ( inputs[i].value != '' ) {
//            unfinished = 'true';
//        }
//    }
//    if ( unfinished == 'true' ) {
//        return "Cette page contient du texte non sauvegardé qui sera perdu si vous quittez la page.";
//    }
//
//}

var warnLeavingUnsavedMessage;

function warn_me(message){
    warnLeavingUnsavedMessage = message;
    $('.simple_form').submit(function(){
        $('textarea').removeData('changed');
        $('input').removeData('changed');
        $('select').removeData('changed');
    });
    $('textarea').change(function(){
        $(this).data('changed', 'changed');
    });
    $('input').change(function(){
        $(this).data('changed', 'changed');
    });
    $('select').change(function(){
        $(this).data('changed', 'changed');
    });
    window.onbeforeunload = function(){
        var warn = false;
        $('textarea').blur().each(function(){
            if ($(this).data('changed')) {
                warn = true;
            }
        });
        $('input').blur().each(function(){
            if ($(this).data('changed')) {
                warn = true;
            }
        });
        $('select').blur().each(function(){
            if ($(this).data('changed')) {
                warn = true;
            }
        });

        if (warn) {return warnLeavingUnsavedMessage;}
    }
}