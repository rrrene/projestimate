#asInitVals = new Array()
#jQuery ->
#  oTable = $('#projects').dataTable
#              sDom: "<'row-fluid'<'span9'l><'span3'f>r>t<'row-fluid'<'span11'i><'span1'p>>"
#              bJQueryUI: true
#              bProcessing: true
#              bServerSide: true
#              sAjaxSource: $('#projects').data('source')
#
#              oLanguage:
#               sLengthMenu: "Display _MENU_ records per page"
#               sZeroRecords: "Nothing found - sorry"
#               sInfo: "Showing _START_ to _END_ of _TOTAL_ records"
#               sInfoEmpty: "Showing 0 to 0 of 0 records"
#               sInfoFiltered: "(filtered from _MAX_ total records)"
#               sSearch: "Quick search"
#
#              $("tfoot input").keyup ->
#               oTable.fnFilter( this.value, $("tfoot input").index(this))
#
#              $("tfoot input").each (i) ->
#               asInitVals[i] = this.value
#
#              $("tfoot input").focus ->
#               if this.className is "search_init"
#                 this.className = ""
#                 this.value = ""
#
#              $("tfoot input").blur (i) ->
#               if this.value is ""
#                 this.className = "search_init"
#                 this.value = asInitVals[$("tfoot input").index(this)]