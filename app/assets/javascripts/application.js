// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require moment
//= require daterangepicker
//= require bootstrap-sprockets
//= require toastr
//= require private_pub
//= require jquery_nested_form
//= require data-confirm-modal
//= require select2
//= require action_cable
//= require cable
//= require jquery.validationEngine-en
//= require jquery.validationEngine
//= require jquery.mask
//= require_tree .

function send_ajax_request(req_type, req_url, data_type, req_data, success_callback, error_callback){
	$.ajax({
		type: req_type,
		url: req_url,
		dataType: data_type,
		data: req_data,
		success: success_callback,
		error: error_callback
	});
}

$(document).ready(function(){
	$('.select2-field').select2();
	// We don't want scroll
	$(".validate_form").validationEngine({ 
		scroll: false
	});
	$('[data-toggle="tooltip"]').tooltip(); 
	$('.popover-dismiss').popover({
        trigger: 'hover',
        container: 'body'
    });
    $('input[id="daterange"]').daterangepicker();
    $('.phone_number_field').mask('0000-0000000');
    $('.cnic_field').mask('00000-0000000-0');   
});
