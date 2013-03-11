class Label
  @labels: []
  @width: 100

  html: null

  constructor: (position) ->
    Label.labels.push(this)
    @html = jQuery('<input type="textfield" value="activity"/>')
    jQuery('#label_bar').append(@html)
    jQuery(@html).change -> StageManager.updateReport()
    StageManager.updateElements()

  offsetX: () ->
    jQuery(@html).offset().left

  setOffsetX: (offsetX) ->
    jQuery(@html).css('left', offsetX)

  kill: () ->
    jQuery(@html).remove()
    _this = @
    Label.labels = Label.labels.filter (l) -> l != _this

  text: () ->
    jQuery(@html).val()

  timeLabel: () ->
    interval = StageManager.getTimeInterval()
#    minute = (@offsetX() / StageManager.timeBarWidth()) * (interval.end - interval.start) + interval.start
#    minute
    null


class Divider
  @dividers: []
  @width: 10
  @widthHalf: @width >> 1
  @counter: 0
  @activeDivider: null

  html: null
  count: @counter++

  constructor: (coordX) ->
    dividerWidthHalf = Divider.width >> 1

    Divider.dividers.push(this)

    @html = jQuery('<div class="divider"/>')
    @html.attr('id', 'divider_' + Divider.counter)
    @setOffsetX(coordX - dividerWidthHalf)
    @html.mousedown (e) =>
      @mouseDown(e)
    @html.click (e) =>
      e.stopPropagation()
    @html.dblclick StageManager.doubleClickOnDivider
    jQuery('#time_bar').append(@html)

    Divider.activeDivider = this
    Divider.counter++

  offsetX: () ->
    jQuery(@html).offset().left

  setOffsetX: (offsetX) ->
    @html.css('left', offsetX)

  mouseDown: (e) ->
    Divider.activeDivider = @
    e.stopPropagation()

  getHTMLAttr: (param) ->
    jQuery(@html).attr(param)

  kill: () ->
    _this = @
    Divider.dividers = Divider.dividers.filter (d) -> d != _this
    jQuery(@html).remove()

  index: () ->
    for divider, i in Divider.dividers
      if divider == @
        return i
    -1

  @getByID: (id) ->
    for divider in Divider.dividers
      if divider.getHTMLAttr('id') == id
        return divider
    null

  @sort: () ->
    Divider.dividers.sort (a, b) ->
      jQuery(a.html).offset().left > jQuery(b.html).offset().left


class StageManager
  @updateElements: () ->
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
    @updateReport()

  @updateReport: ->
    jQuery('#report').html('<ol />')
    for label in Label.labels
      text = label.text()
      jQuery('#report ol').append('<li>' + text + ' ' + label.timeLabel() + '</li>')

  @moveBarMouseMove: (e) ->
    if Divider.activeDivider
      Divider.activeDivider.setOffsetX(e.offsetX - Divider.widthHalf)

  @timeBarMouseUp: () ->
    Divider.activeDivider = null
    Divider.sort()
    StageManager.updateElements()

  @onClickTimeBar: (e) ->
    new Divider(e.offsetX)
    new Label(0)

  @doubleClickOnDivider: (e) ->
    id = jQuery(e.delegateTarget).attr('id')
    divider_to_kill = Divider.getByID(id)

    idx_of_divider = divider_to_kill.index()
    Label.labels[idx_of_divider].kill()

    divider_to_kill.kill()

  @getTimeInterval: () ->
    {
      start: 540,
      end: 1080
    }

  @timeBarWidth: ->
    jQuery('#label_bar').width()


jQuery ->
  jQuery('#time_bar').click StageManager.onClickTimeBar
  jQuery('#time_bar').mouseup StageManager.timeBarMouseUp
  jQuery('#move_layer').mousemove StageManager.moveBarMouseMove
  new Label()
