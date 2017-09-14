$(document).on "turbolinks:load", ->
  $('#groups-list').dataTable 'paging': false
  $('[id^=group-table-]').dataTable
    'searching': false
    'paging': false
    'info': false
    'autoWidth': false
  return