function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}
function onlyNumber(field, rules, i, options){
  if (!isNumber(field.val())) {
     return "* Price must be a number";
  }
}
$(document).ready(function(){
    $(document).on('nested:fieldAdded:photos', function(event){
	var field = event.field; 
	field.find('.pic-upload-field').click();
    })
    //first form validations then this code
    $('#btn-create-room').on('click', function() {
	/* if  (document.getElementsByClassName("pic-upload-field").length == 0) {
	   toastr.error("Please upload at least one picture");
	   return false;
	   }*/
	
    });
    $('body').on('change', '.pic-upload-field', function(){
	$(this).parent().parent().find('.filename-para').html($(this).val().split("\\")[2]);
    });
    $('body').on('change', '#room_location', function(){
	// 1. Fetch a place with id come from the location select box
	// 2. Set center of circle to the latitude and longitude of selected place
	var place_id = 1;
	if($(this).val() != ""){
	    place_id = $(this).val();
	}
	send_ajax_request("POST", 
			  "/places/get_place",
			  "script",
			{
			    id: place_id 
			},
			  function(data){
			      // console.log(data);
			  },
			  function(jqXHR, exception){
			      console.log(exception);
			  }
			 );
    });

    $('body').on('submit', '.room_form', function(){
	var latitude = map_marker.getPosition().lat();
	var longitude = map_marker.getPosition().lng();
	$('.latitude_field').val(latitude);
	$('.longitude_field').val(longitude);		
    });
    
    $('#room_location').select2();
    $('.switch-wrapper').find("input[type=checkbox]").switchButton({
	on_label: 'yes',
	off_label: 'no'
    });
    
    // When someone click on Add we have to add nested field and then register a event on nested field add
    // in that event I have to populate values in fields of nested form
    $('body').on('click', '#add-rule-btn', function(e){
	if ($('#shared-rule-title').val() == "") {
	    return false;
        }
	$('#add_house_rule').click();
	e.preventDefault();
    });
    $(document).on('nested:fieldAdded:house_rules', function(event){
	// this field was just inserted into your form
	var field = event.field; 
	$(field.find('.title-input')).val($('#shared-rule-title').val());
	$('#shared-rule-title').val("");
    });
    
    $('body').on('change', '.price_enabled_checkbox', function(){
	if($(this).is(":checked")){
	    $(this).parent().find(".price-field").prop("disabled", false);
	}
	else{
	    $(this).parent().find(".price-field").val("");
	    $(this).parent().find(".price-field").prop("disabled", true);
	}
    });
    
    $('.room-slider').slick({
			infinite: false,
			speed: 300,
			slidesToShow: 1,
			slidesToScroll: 1,
			arrows: true,
			responsive: [
			  {
					breakpoint: 1024,
					settings: {
					    slidesToShow: 1,
					    slidesToScroll: 1
					}
			  },
			  {
					breakpoint: 800,
					settings: {
					    slidesToShow: 1,
					    slidesToScroll: 1,
					    dots: true,
					    infinite: true,
					}
			  },
			  {
					breakpoint: 600,
					settings: {
					    slidesToShow: 1,
					    slidesToScroll: 1
					}
			  },
			  {
					breakpoint: 480,
					settings: {
					    slidesToShow: 1,
					    slidesToScroll: 1,
					}
			  }
			]
    });
});
