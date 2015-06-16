/* +++++++++ THEMELOUNGE +++++++++++     
 +
 + Custom JavaScript Functions
 + 
 + Theme:  Carote	       
 + Author: Valentin Scholz
 + Support: http://valentinscholz.com/support
 + Version: 1.0
*/
$(document).ready(function() {

	$('.price-table-toggle').click(function () {
	
		var thisparent = $(this).parents('.pricing-table');
		$('.price-table-features', thisparent).fadeToggle('slow');
		
		if($(this).html()=='+ Show features')
			$(this).html('- Hide features');	
		else {	
			$(this).html('+ Show features');	
		}
	});
	
	/* Styleswitcher */
	
	$('.collapse').click(function () {
		$('.styleswitcher').toggleClass('active'); 
	});
	
	$('.switch-color').click(function () {
		var color = $(this).attr('id');
		$('body').removeClass().addClass(color);
	});
		
});