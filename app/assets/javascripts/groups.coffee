$(document).on "turbolinks:load", ->
  $('#groups-list').dataTable 'paging': false
  $('[id^=group-table-]').dataTable
    'searching': false
    'paging': false
    'info': false
    'autoWidth': false
    'columns': [
      { "type": "num" },
      { "type": "string" },
      { "type": "num" },
      { "type": "string" },
      { "type": "string" },
      { "type": "num" },
      { "type": "num" },
      { "type": "num" },
      { "type": "num" },
      { "type": "num" },
    ]
  return