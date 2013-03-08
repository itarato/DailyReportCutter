class Label
  this.labels = []
  this.width = 100

  html: null

  constructor: (position) ->
    console.log('New label')
    @html = jQuery('<input type="textfield" value="activity"/>')
    jQuery('#label_bar').append(@html)
    Label.labels.unshift(this)
    Label.updateAll()

  setOffsetX: (offsetX) ->
    jQuery(@html).css('left', offsetX)

  kill: () ->
    jQuery(@html).remove()
    _this = this
    Label.labels = Label.labels.filter (l) -> l != _this

  this.updateAll = () ->
    labelWidthHalf = Label.width >> 1
    if Divider.dividers.length == 0
      bar_width_half = jQuery('#label_bar').width() >> 1
      jQuery(Label.labels[0]).css('left', bar_width_half - labelWidthHalf)
    else
      prev_x = 0

      for divider, i in Divider.dividers
        divider_x = divider.offsetX()
        label_x = (divider_x + prev_x) * 0.5 - labelWidthHalf
        label_i = Label.labels[i]
        label_i.setOffsetX(label_x)
        prev_x = divider_x

      label_i = Label.labels[i]
      label_i.setOffsetX((jQuery('#label_bar').width() + prev_x) * 0.5 - labelWidthHalf)

class Divider
  this.dividers = []
  this.width = 10
  this.widthHalf = this.width >> 1
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
    this.setOffsetX(event.offsetX - dividerWidthHalf)
    @html.mousedown (event) =>
      this.mouseDown(event)
    @html.click (event) =>
      event.stopPropagation()

    @html.dblclick(this.doubleClick)

    jQuery('#time_bar').append(@html)
    jQuery('#time_bar').mouseup(timeBarMouseUp)
    jQuery('#move_layer').mousemove(moveBarMouseMove)

    Divider.activeDivider = this

    LabelFactory.addLabel(0)

    Divider.counter++

  offsetX: () ->
    jQuery(@html).offset().left

  setOffsetX: (offsetX) ->
    @html.css('left', offsetX)

  mouseDown: (event) ->
    Divider.activeDivider = this
    event.stopPropagation()

  getHTMLAttr: (param) ->
    jQuery(@html).attr(param)

  kill: () ->
    # @todo add even instead of knowing about label
    for divider, i in Divider.dividers
      if divider == this
        Label.labels[i].kill()

    _this = this
    Divider.dividers = Divider.dividers.filter (d) -> d != _this
    jQuery(@html).remove()

  /// Remove divider and label. ///
  doubleClick: (event) ->
    id = jQuery(event.delegateTarget).attr('id')
    divider_to_kill = Divider.dividerByID(id)
    divider_to_kill.kill()

  this.dividerByID = (id) ->
    for divider in Divider.dividers
      if divider.getHTMLAttr('id') == id
        return divider
    null

  this.sortDividers = () ->
    Divider.dividers.sort (a, b) ->
      jQuery(a.html).offset().left > jQuery(b.html).offset().left

class LabelFactory
  this.addLabel = (position) ->
    new Label(position)

class DividerFactory
  this.addDivider = (event) ->
    new Divider(event.offsetX)

window.timeBarMouseUp = () ->
  Divider.activeDivider = null
  Divider.sortDividers()
  Label.updateAll()

window.moveBarMouseMove = (event) ->
  if Divider.activeDivider
    Divider.activeDivider.setOffsetX(event.offsetX - Divider.widthHalf)

jQuery =>
  jQuery('#time_bar').click(DividerFactory.addDivider);
  # First divider.
  LabelFactory.addLabel()
