
$(document).on "turbolinks:load", ->
  $('#players').dataTable
    'lengthMenu': [
      [
        50
        100
        -1
      ]
      [
        50
        100
        'All'
      ]
    ]
    'order': [
      6
      'desc'
    ]
    'columnDefs': [ {
      className: 'dt-center'
      'targets': '_all'
    } ]
    'autoWidth': 'false'
  return
