jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function() {
	//if($('div.flash').length > 0) {
	//	setTimeout("$('div.flash').hide('slide', { direction: 'up' }, 1000)", 5000);
	//}
  //

  $(".star-rating a").click(function(){
    var name_element = $(this).parents('ul').attr('id');
    var name_id = name_element.split('_').pop();
    var vote = $(this).text();

    jQuery.post('/' + name_id + '/vote', { "rating": vote }, function(response){
      $('#'+name_element+' .current-rating').replaceWith(response);
    });
  });
});

