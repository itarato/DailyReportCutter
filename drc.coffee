console.log('Init')

class Divider
  this.dividers = []

  this.width = 10

  constructor: () ->
    Divider.dividers.push(this)

class DividerFactory
  this.addDivider = () ->
    new Divider()

DividerFactory.addDivider()
