var dividers = [];
var activeDivider = null;
var dividerWidth = 10;
var dividerWidthHalf = dividerWidth >> 1;
var dividerCounter = 0;

jQuery(function(){
  console.log('Init.');

  jQuery('#time_bar').click(addDivider);
});

function addDivider(event) {
  var divider = jQuery('<div class="divider"/>');
  divider.attr('id', 'divider_' + dividerCounter);
  divider.css('left', event.offsetX - dividerWidthHalf);
  divider.mousedown(dividerMouseDown);
  divider.click(function(event){event.stopPropagation();});
  divider.dblclick(dividerDoubleClick);
  jQuery('#time_bar').append(divider);
  jQuery('#time_bar').mouseup(dividerMouseUp);
  jQuery('#move_layer').mousemove(dividerMouseMove);
  dividers.push(divider);
  activeDivider = divider;
  dividerCounter++;
}

function dividerMouseDown(event) {
  console.log(event.delegateTarget);
  activeDivider = event.delegateTarget;
  event.stopPropagation();
}

function dividerMouseMove(event) {
  if (activeDivider) {
    jQuery(activeDivider).css('left', event.offsetX - dividerWidthHalf);
  }
}

function dividerMouseUp(event) {
  activeDivider = null;
}

function dividerDoubleClick(event) {
  var id = jQuery(event.delegateTarget).attr('id');
  for (var i = 0; i < dividers.length; i++) {
    if (dividers[i].attr('id') == id) {
      dividers[i].remove();
      delete dividers[i];
      return;
    }
  }
}
