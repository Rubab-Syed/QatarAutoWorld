$(document).ready(function(){
  //Price range slider
  if (localStorage.length != 0) {
    min = localStorage.min;
    max = localStorage.max;
  } else {
    min = 0;
    max = 10000;
  }
  //spinner
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

  $(document).on('submit', '#signup_form', function() {
    var target = document.getElementById('signup_spinner');
    var spinner = new Spinner(opts).spin(target);
    $('#signup_details_modal_h').on('hidden.bs.modal', function () {
     spinner.stop();
    });
  });

  $(function() {
    // $("#slider-range").slider({
    //   range: true,
    //   min: 0,
    //   max: 10000,
    //   step: 100,
    //   values: [min, max],
    //   slide: function(event, ui) {
    //       $("#amount").val("Rs. " + ui.values[ 0 ] + " - Rs. " + ui.values[ 1 ] );
    //   }
    // });

    $("#btn_search_page").click(function(){
    	min = $('#slider-range').slider("values", 0);
    	max = $('#slider-range').slider("values", 1);
    	
    	// validation
    	if (min === max) {
    	    toastr.error("Max and min price can't be same");
    	    return false;
            } else {
              $("#q_price_gteq").val($("#slider-range").slider("values", 0));
              $("#q_price_lteq").val($("#slider-range").slider("values", 1));
              localStorage.setItem('min', $("#slider-range").slider("values", 0));
              localStorage.setItem('max', $("#slider-range").slider("values", 1));
    	}
    });

    $("#amount").val("Rs. " + $("#slider-range" ).slider( "values", 0) + " - Rs. " + $( "#slider-range" ).slider( "values", 1 ) );
  });

  $(function() {
    $("#start_date").datepicker({
      dateFormat: 'dd-mm-yy',
      minDate: 0,
      maxDate: '3m',
      onSelect: function(selected) {
        $('#end_date').datepicker("option", "minDate", selected);
        $('#end_date').attr('disabled', false);
      }
    });
    $("#end_date").datepicker({
      dateFormat: 'dd-mm-yy',
      minDate: 0,
      maxDate: '3m',
      onSelect: function(selected) {
        $('#start_date').datepicker("option", "maxDate", selected);
      }
    });
  })

  $(function() {
    $("#btn_home_search").click(function(){
      localStorage.clear();
    });
  });
  // We have to clear search box on home page before select2 initialization
  // but on search page we have to retain value
  $('.pages.home #search').val([]);
  $('.search_select_field').select2({
    theme: "bootstrap",
    placeholder: 'Search Places',
    tags: true,
    multiple: true,
    maximumSelectionLength: 1,
    minimumResultsForSearch: Infinity,
    width: '100%'
  });
  $(".widget h2").click(
    function() {
      $(this).parent().toggleClass('active');
    }
  );

// Slick slider
  $('.home-slider').slick({
    infinite: false,
    speed: 300,
    slidesToShow: 3,
    slidesToScroll: 1,
    arrows: true,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 4,
          slidesToScroll: 1
        }
      }, 
      {
        breakpoint: 800,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
          dots: true,
      		infinite: true,
        }
      }, 
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2
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

$(window).ready(function(){
  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
  var checkin = $('#checkin').datepicker({
    onRender: function(date) {
      return date.valueOf() < now.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev) {
    if (ev.date.valueOf() > checkout.date.valueOf()) {
      var newDate = new Date(ev.date)
      newDate.setDate(newDate.getDate() + 1);
      checkout.setValue(newDate);
    }
    checkin.hide();
    $('#checkout')[0].focus();
  }).data('datepicker');
  var checkout = $('#checkout').datepicker({
    onRender: function(date) {
      return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev) {
    checkout.hide();
  }).data('datepicker');
  
  $('body').on('click','.open-datepicker-span', function(){
    $(this).parent().find('input').datepicker('show');
  });
});
