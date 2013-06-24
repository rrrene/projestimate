/*
 * ProjEstimate code overload for Table Sorted
 */

$(document).ready(function() {
    $(function table_sorter_filter() {

        var pagerOptions = {

            // target the pager markup - see the HTML block below
            container: $(".pager"),

            // use this url format "http:/mydatabase.com?page={page}&size={size}&{sortList:col}"
            ajaxUrl: null,

            // modify the url after all processing has been applied
            customAjaxUrl: function(table, url) { return url; },

            // process ajax so that the data object is returned along with the total number of rows
            // example: { "data" : [{ "ID": 1, "Name": "Foo", "Last": "Bar" }], "total_rows" : 100 }
            ajaxProcessing: function(ajax){
                if (ajax && ajax.hasOwnProperty('data')) {
                    // return [ "data", "total_rows" ];
                    return [ ajax.total_rows, ajax.data ];
                }
            },

            // output string - default is '{page}/{totalPages}'
            // possible variables: {page}, {totalPages}, {filteredPages}, {startRow}, {endRow}, {filteredRows} and {totalRows}
            output: '{startRow} - {endRow} / {filteredRows} ({totalRows})',

            // apply disabled classname to the pager arrows when the rows at either extreme is visible - default is true
            updateArrows: true,

            // starting page of the pager (zero based index)
            page: 0,

            // Number of visible rows - default is 10
            size: 10,

            // if true, the table will remain the same height no matter how many records are displayed. The space is made up by an empty
            // table row set to a height to compensate; default is false
            fixedHeight: false,

            // remove rows from the table to speed up the sort of large tables.
            // setting this to false, only hides the non-visible rows; needed if you plan to add/remove rows with the pager enabled.
            removeRows: false,

            // css class names of pager arrows
            cssNext: '.next', // next page arrow
            cssPrev: '.prev', // previous page arrow
            cssFirst: '.first', // go to first page arrow
            cssLast: '.last', // go to last page arrow

            cssGoto  : ".pagenum",
            cssPageDisplay: '.pagedisplay', // location of where the "output" is displayed
            cssPageSize: '.pagesize', // page size selector - select dropdown that sets the "size" option

            // class added to arrows when at the extremes (i.e. prev/first arrows are "disabled" when on the first page)
            cssDisabled: 'disabled', // Note there is no period "." in front of this class name
            cssErrorRow: 'tablesorter-errorRow' // ajax error information row

        };

        $.extend($.tablesorter.themes.bootstrap, {
            // these classes are added to the table. To see other table classes available,
            // look here: http://twitter.github.com/bootstrap/base-css.html#tables
            table      : 'table table-bordered',
            header     : 'bootstrap-header', // give the header a gradient background
            footerRow  : '',
            footerCells: '',
            icons      : '', // add "icon-white" to make them white; this icon class is added to the <i> in the header
            sortNone   : 'bootstrap-icon-unsorted',
            sortAsc    : 'icon-chevron-up',
            sortDesc   : 'icon-chevron-down',
            active     : '', // applied when column is sorted
            hover      : '', // use custom css here - bootstrap class may not override it
            filterRow  : '', // filter row class
            even       : '', // odd row zebra striping
            odd        : ''  // even row zebra striping
        });
        $("table thead th.action").data({
            sorter: false,
            filter: false
        });
        // call the tablesorter plugin and apply the uitheme widget
        $("table")
            .tablesorter({
                // this will apply the bootstrap theme if "uitheme" widget is included
                // the widgetOptions.uitheme is no longer required to be set
                theme : "bootstrap",
                widthFixed: true,
                sortList: [[0,0]],
                headerTemplate : '{content} {icon}', // new in v2.7. Needed to add the bootstrap icon!
                debug: true,
                dateFormat       : 'ddmmyyyy',
                // widget code contained in the jquery.tablesorter.widgets.js file
                // use the zebra stripe widget if you plan on hiding any rows (filter widget)

                widgets: [ 'uitheme', 'zebra', 'filter'],
                widgetOptions : {

                    zebra : ["even", "odd"],

                    // reset filters button
                    filter_reset : ".reset"
                }

            })
            // bind to pager events
            // *********************
            .bind('pagerChange pagerComplete pagerInitialized pageMoved', function(e, c){
                var msg = '"</span> event triggered, ' + (e.type === 'pagerChange' ? 'going to' : 'now on') +
                    ' page <span class="typ">' + (c.page + 1) + '/' + c.totalPages + '</span>';
                $('#display')
                    .append('<li><span class="str">"' + e.type + msg + '</li>')
                    .find('li:first').remove();
            })

            // initialize the pager plugin
            // ****************************
            .tablesorterPager(pagerOptions);





    });


});

