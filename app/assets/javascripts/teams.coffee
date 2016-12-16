$(document).on "turbolinks:load", ->
  $('#teams').dataTable 'paging': false
  return