/* ProjEstimate, Open Source project estimation web application
 * Copyright (c) 2012-2013 Spirula (http://www.spirula.fr)
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU Affero General Public License as
 *    published by the Free Software Foundation, either version 3 of the
 *    License, or (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU Affero General Public License for more details.
 *
 *    You should have received a copy of the GNU Affero General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

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