$(document).ready(function() {
  $('#groups-list').dataTable();
  $('[id^=group-table-]').dataTable( {
    "searching": false,
    "paging": false,
    "info": false
  });
});