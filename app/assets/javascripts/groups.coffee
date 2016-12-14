$(document).ready ->
  $('#groups-list').dataTable 'paging': false
  $('[id^=group-table-]').dataTable
    'searching': false
    'paging': false
    'info': false
  return