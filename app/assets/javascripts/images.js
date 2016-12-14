$( document ).ready(function() {

  // hide spinner
  $(".overlay").hide();


  // show spinner on AJAX start
  $(document).ajaxStart(function(){
    $(".overlay").show();
  });

  // hide spinner on AJAX stop
  $(document).ajaxStop(function(){
    $(".overlay").hide();
  });

});