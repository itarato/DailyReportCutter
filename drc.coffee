console.log('Init')

class Label
  this.labels = []
  this.width = 100

  constructor: () ->
    console.log('New label')
    Label.labels.push(this)
    label_html = jQuery('<input type="textfield" value="activity"/>')
    jQuery('#label_bar').append(label_html)
    Label.labels.unshift(label_html)
    Label.updateAll()

  this.updateAll = () ->
    labelWidthHalf = Label.width >> 1
    if Divider.dividers.length == 0
      bar_width_half = jQuery('#label_bar').width() >> 1
      jQuery(Label.labels[0]).css('left', bar_width_half - labelWidthHalf)
    else
      prev_x = 0

      for divider, i in Divider.dividers
        divider_x = jQuery(divider).offset().left
        label_x = (divider_x + prev_x) * 0.5 - labelWidthHalf
        jQuery(Label.labels[i]).css('left', label_x)
        prev_x = divider_x

      jQuery(Label.labels[i]).css('left', (jQuery('#label_bar').width() + prev_x) * 0.5 - labelWidthHalf)

class Divider
  this.dividers = []
  this.width = 10
  this.counter = 0
  this.activeDivider = null

  html: null

  count: this.counter++

  constructor: (coordX) ->
    dividerWidthHalf = Divider.width >> 1

    console.log('New divider')
    Divider.dividers.push(this)
    @html = jQuery('<div class="divider"/>')

    @html.attr('id', 'divider_' + Divider.counter)
    @html.css('left', event.offsetX - dividerWidthHalf)

    @html.mousedown(this.mouseDown)
    @html.click =>
      @event.stopPropagation()

    @html.dblclick(this.doubleClick)

    jQuery('#time_bar').append(@html)
    jQuery('#time_bar').mouseup(timeBarMouseUp)
    jQuery('#move_layer').mousemove(moveBarMouseMove);

    Divider.activeDivider = this

    addLabel(0)

    Divider.counter++

  mouseDown: (event) ->

  doubleClick: (event) ->

class LabelFactory
  this.addLabel = () ->
    new Label()

class DividerFactory
  this.addDivider = (event) ->
    new Divider(event.offsetX)

timeBarMouseUp: () ->

moveBarMouseMove: () ->

jQuery =>
  jQuery('#time_bar').click(DividerFactory.addDivider);
  # First divider.
  LabelFactory.addLabel()
