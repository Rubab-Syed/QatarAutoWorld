$(document).ready(function(){
  // reservation spinner
  var opts = {
    lines: 17 // The number of lines to draw                                                                                                   
    , length: 39 // The length of each line                                                                                                    
    , width: 10 // The line thickness                                                                                                          
    , radius: 20 // The radius of the inner circle                                                                                             
    , scale: 0.65 // Scales overall size of the spinner                                                                                        
    , corners: 1 // Corner roundness (0..1)                                                                                                    
    , color: '#e00007' // #rgb or #rrggbb or array of colors                                                                                   
    , opacity: 0.2 // Opacity of the lines                                                                                                     
    , rotate: 0 // The rotation offset                                                                                                         
    , direction: 1 // 1: clockwise, -1: counterclockwise                                                                                       
    , speed: 1 // Rounds per second                                                                                                            
    , trail: 60 // Afterglow percentage                                                                                                        
    , fps: 20 // Frames per second when using setTimeout() as a fallback for CSS                                                               
    , zIndex: 2e9 // The z-index (defaults to 2000000000)                                                                                      
    , className: 'spinner' // The CSS class to assign to the spinner                                                                           
    , top: '50%' // Top position relative to parent                                                                                            
    , left: '50%' // Left position relative to parent                                                                                          
    , shadow: false // Whether to render a shadow                                                                                              
    , hwaccel: false // Whether to use hardware acceleration                                                                                  
    , position: 'absolute' // Element positioning                                                                                              
  }

  var spinner = new Spinner(opts).spin()

  $( "#tabs" ).tabs();
  $('body').on('change', '.reservation-type-select', function(){
    $('.reservation-price').addClass('hidden');
    $('.reservation_type_specific_fields').addClass('hidden');
    $("." + $(this).val() + "-reservation-price").removeClass('hidden');
    $("." + $(this).val() + "_fields").removeClass('hidden');
  });
  $("." + $(".reservation-type-select").val() + "-reservation-price").removeClass('hidden');
  $("." + $(".reservation-type-select").val() + "_fields").removeClass('hidden');

  $('body').on('change', '.reservation-type-select', function(){
    if($('.calculate-rent:visible').val() == ""){
      $('.rent-detail-div').addClass('hidden');
    }
    else{
      $('.calculate-rent:visible').trigger('change');		
    }
  });

  $('#booking_details_modal').on('shown.bs.modal', function () {
    spinner.stop();
    if($('.reservation-type-select').val() == "nightly"){
      var type = "Daily";
      var units = parseInt($('#reservation_num_days').val());
      var total = units * parseInt($('.nightly-reservation-price').text().slice(3));
    } else if ($('.reservation-type-select').val() == "weekly"){
      var type = "Weekly";
      var units = parseInt($('#reservation_num_weeks').val());
      var total = units * parseInt($('.weekly-reservation-price').text().slice(3));
    } else if ($('.reservation-type-select').val() == "monthly"){
      var type = "Monthly";
      var units = parseInt($('#reservation_num_months').val());										
      var total = units * parseInt($('.monthly-reservation-price').text().slice(3));
    }
    var service_charges = Math.round((total / 100) * 17.5);
    var sum = total + service_charges;
    $('#service_charges').text("Rs. " + service_charges);
    $('#price_type').text(type);
    $('#unit_periods').text(units);
    $('#price_total').text("Rs. " + total);
    $('#final_total').text("Rs. " + sum); 
  });

  $('#btn_book').on('click', function() {
    var res_val = $('#reservation_start_date').val();
    if (res_val === "") {
      toastr.error("Please select a Check-In date");
      return false;
    }
    var res_weeks = $('#reservation_num_weeks').val();
    var res_days = $('#reservation_num_days').val();
    var res_months = $('#reservation_num_months').val();
    if (res_weeks === "" && res_days === "" && res_months === "") {
      toastr.error("Please enter number of periods of your stay");
      return false;
    }
    var target = document.getElementById('reservation_spinner');
    target.appendChild(spinner.el)
  });
});
