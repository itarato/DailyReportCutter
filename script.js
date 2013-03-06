//var dividers = [];
//var labels = [];
//var activeDivider = null;
//var dividerWidth = 10;
//var dividerWidthHalf = dividerWidth >> 1;
//var dividerCounter = 0;
//var labelWidth = 100;
//var labelWidthHalf = labelWidth >> 1;

//jQuery(function(){
//  console.log('Init.');
//
//  jQuery('#time_bar').click(addDivider);
//
//  addLabel(0);
//});

//function addDivider(event) {
//  var divider = jQuery('<div class="divider"/>');
//
//  divider.attr('id', 'divider_' + dividerCounter);
//  divider.css('left', event.offsetX - dividerWidthHalf);
//
//  divider.mousedown(dividerMouseDown);
//  divider.click(function(event){event.stopPropagation();});
//  divider.dblclick(dividerDoubleClick);
//
//  jQuery('#time_bar').append(divider);
//  jQuery('#time_bar').mouseup(dividerMouseUp);
//  jQuery('#move_layer').mousemove(dividerMouseMove);
//
//  dividers.push(divider);
//  activeDivider = divider;
//
//  // @todo Use right position.
//  addLabel(0);
//
//  dividerCounter++;
//}

//function dividerMouseDown(event) {
//  console.log(event.delegateTarget);
//  activeDivider = event.delegateTarget;
//  event.stopPropagation();
//}

//function dividerMouseMove(event) {
//  if (activeDivider) {
//    jQuery(activeDivider).css('left', event.offsetX - dividerWidthHalf);
//  }
//}

//function dividerMouseUp(event) {
//  activeDivider = null;
//  dividers.sort(function(a, b) {
//    return jQuery(a).offset().left > jQuery(b).offset().left;
//  });
//  updateLabels();
//}

function dividerDoubleClick(event) {
  var id = jQuery(event.delegateTarget).attr('id');
  for (var i = 0; i < dividers.length; i++) {
    if (dividers[i].attr('id') == id) {
      dividers[i].remove();
      dividers = dividers.slice(0, i - 1).concat(dividers.slice(i));
      return;
    }
  }
}

//function addLabel(position) {
//  var label = jQuery('<input type="textfield" value="activity"/>');
//  jQuery('#label_bar').append(label);
//  labels.unshift(label);
//  updateLabels();
//}

//function updateLabels() {
//  if (dividers.length == 0) {
//    var bar_width_half = jQuery('#label_bar').width() >> 1;
//    jQuery(labels[0]).css('left', bar_width_half - labelWidthHalf);
//  }
//  else {
//    var prev_x = 0;
//    for (var i = 0; i < dividers.length; i++) {
//      var divider_x = jQuery(dividers[i]).offset().left;
//      var label_x = (divider_x + prev_x) * 0.5 - labelWidthHalf;
//      jQuery(labels[i]).css('left', label_x);
//      prev_x = divider_x;
//    }
//    jQuery(labels[i]).css('left', (jQuery('#label_bar').width() + prev_x) * 0.5 - labelWidthHalf);
//  }
//}
