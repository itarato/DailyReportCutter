class Label
  this.labels = []
  this.width = 100

  html: null

  constructor: (position) ->
    Label.labels.unshift(this)
    @html = jQuery('<input type="textfield" value="activity"/>')
    jQuery('#label_bar').append(@html)
    StageManager.updateElements()

  setOffsetX: (offsetX) ->
    jQuery(@html).css('left', offsetX)

  kill: () ->
    jQuery(@html).remove()
    _this = this
    Label.labels = Label.labels.filter (l) -> l != _this


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

    Divider.dividers.push(this)

    @html = jQuery('<div class="divider"/>')
    @html.attr('id', 'divider_' + Divider.counter)
    this.setOffsetX(coordX - dividerWidthHalf)
    @html.mousedown (e) =>
      this.mouseDown(e)
    @html.click (e) =>
      e.stopPropagation()
    @html.dblclick (e) =>
     StageManager.doubleClickOnDivider(e)
    jQuery('#time_bar').append(@html)

    Divider.activeDivider = this
    Divider.counter++

  offsetX: () ->
    jQuery(@html).offset().left

  setOffsetX: (offsetX) ->
    @html.css('left', offsetX)

  mouseDown: (e) ->
    Divider.activeDivider = this
    e.stopPropagation()

  getHTMLAttr: (param) ->
    jQuery(@html).attr(param)

  kill: () ->
    _this = this
    Divider.dividers = Divider.dividers.filter (d) -> d != _this
    jQuery(@html).remove()

  index: () ->
    for divider, i in Divider.dividers
      if divider == this
        return i
    -1

  this.getByID = (id) ->
    for divider in Divider.dividers
      if divider.getHTMLAttr('id') == id
        return divider
    null

  this.sort = () ->
    Divider.dividers.sort (a, b) ->
      jQuery(a.html).offset().left > jQuery(b.html).offset().left


class StageManager
  this.updateElements = () ->
    labelWidthHalf = Label.width >> 1
    if Divider.dividers.length == 0
      bar_width_half = jQuery('#label_bar').width() >> 1
      Label.labels[0].setOffsetX(bar_width_half - labelWidthHalf)
    else
      prev_x = 0
      for divider, i in Divider.dividers
        divider_x = divider.offsetX()
        label_x = (divider_x + prev_x) * 0.5 - labelWidthHalf
        Label.labels[i].setOffsetX(label_x)
        prev_x = divider_x
      label_i = Label.labels[i]
      label_i.setOffsetX((jQuery('#label_bar').width() + prev_x) * 0.5 - labelWidthHalf)

  this.moveBarMouseMove = (e) ->
    if Divider.activeDivider
      Divider.activeDivider.setOffsetX(e.offsetX - Divider.widthHalf)

  this.timeBarMouseUp = () ->
    Divider.activeDivider = null
    Divider.sort()
    StageManager.updateElements()

  this.onClickTimeBar = (e) ->
    new Divider(e.offsetX)
    new Label(0)

  this.doubleClickOnDivider = (e) ->
    id = jQuery(e.delegateTarget).attr('id')
    divider_to_kill = Divider.getByID(id)

    idx_of_divider = divider_to_kill.index()
    Label.labels[idx_of_divider].kill()

    divider_to_kill.kill()


jQuery =>
  jQuery('#time_bar').click (e) => StageManager.onClickTimeBar(e)
  jQuery('#time_bar').mouseup(StageManager.timeBarMouseUp)
  jQuery('#move_layer').mousemove(StageManager.moveBarMouseMove)
  new Label()
