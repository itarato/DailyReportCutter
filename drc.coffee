console.log('Init')

class Label
  this.width = 100

  this.labels = []

  constructor: () ->
    console.log('New label')
    Label.labels.push(this)
    label_html = jQuery('<input type="textfield" value="activity"/>');
    jQuery('#label_bar').append(label_html);
    Label.labels.unshift(label_html);
    Label.updateAll()

  this.updateAll = () ->


class Divider
  this.dividers = []

  this.width = 10

  constructor: () ->
    console.log('New divider')
    Divider.dividers.push(this)

class LabelFactory
  this.addLabel = () ->
    new Label()

class DividerFactory
  this.addDivider = () ->
    new Divider()

jQuery =>
  # First divider.
  LabelFactory.addLabel()
