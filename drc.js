//@ sourceMappingURL=drc.map
// Generated by CoffeeScript 1.6.0
(function() {
  var Divider, DividerFactory, Label, LabelFactory,
    _this = this;

  Label = (function() {

    Label.labels = [];

    Label.width = 100;

    Label.prototype.html = null;

    function Label(position) {
      console.log('New label');
      this.html = jQuery('<input type="textfield" value="activity"/>');
      jQuery('#label_bar').append(this.html);
      Label.labels.unshift(this);
      Label.updateAll();
    }

    Label.prototype.setOffsetX = function(offsetX) {
      return jQuery(this.html).css('left', offsetX);
    };

    Label.prototype.kill = function() {
      var _this;
      jQuery(this.html).remove();
      _this = this;
      return Label.labels = Label.labels.filter(function(l) {
        return l !== _this;
      });
    };

    Label.updateAll = function() {
      var bar_width_half, divider, divider_x, i, labelWidthHalf, label_i, label_x, prev_x, _i, _len, _ref;
      labelWidthHalf = Label.width >> 1;
      if (Divider.dividers.length === 0) {
        bar_width_half = jQuery('#label_bar').width() >> 1;
        return jQuery(Label.labels[0]).css('left', bar_width_half - labelWidthHalf);
      } else {
        prev_x = 0;
        _ref = Divider.dividers;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          divider = _ref[i];
          divider_x = divider.offsetX();
          label_x = (divider_x + prev_x) * 0.5 - labelWidthHalf;
          label_i = Label.labels[i];
          label_i.setOffsetX(label_x);
          prev_x = divider_x;
        }
        label_i = Label.labels[i];
        return label_i.setOffsetX((jQuery('#label_bar').width() + prev_x) * 0.5 - labelWidthHalf);
      }
    };

    return Label;

  })();

  Divider = (function() {

    Divider.dividers = [];

    Divider.width = 10;

    Divider.widthHalf = Divider.width >> 1;

    Divider.counter = 0;

    Divider.activeDivider = null;

    Divider.prototype.html = null;

    Divider.prototype.count = Divider.counter++;

    function Divider(coordX) {
      var dividerWidthHalf,
        _this = this;
      dividerWidthHalf = Divider.width >> 1;
      console.log('New divider');
      Divider.dividers.push(this);
      this.html = jQuery('<div class="divider"/>');
      this.html.attr('id', 'divider_' + Divider.counter);
      this.setOffsetX(event.offsetX - dividerWidthHalf);
      this.html.mousedown(function(event) {
        return _this.mouseDown(event);
      });
      this.html.click(function(event) {
        return event.stopPropagation();
      });
      this.html.dblclick(this.doubleClick);
      jQuery('#time_bar').append(this.html);
      jQuery('#time_bar').mouseup(timeBarMouseUp);
      jQuery('#move_layer').mousemove(moveBarMouseMove);
      Divider.activeDivider = this;
      LabelFactory.addLabel(0);
      Divider.counter++;
    }

    Divider.prototype.offsetX = function() {
      return jQuery(this.html).offset().left;
    };

    Divider.prototype.setOffsetX = function(offsetX) {
      return this.html.css('left', offsetX);
    };

    Divider.prototype.mouseDown = function(event) {
      Divider.activeDivider = this;
      return event.stopPropagation();
    };

    Divider.prototype.getHTMLAttr = function(param) {
      return jQuery(this.html).attr(param);
    };

    Divider.prototype.kill = function() {
      var divider, i, _i, _len, _ref, _this;
      _ref = Divider.dividers;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        divider = _ref[i];
        if (divider === this) {
          Label.labels[i].kill();
        }
      }
      _this = this;
      Divider.dividers = Divider.dividers.filter(function(d) {
        return d !== _this;
      });
      return jQuery(this.html).remove();
    };

    /Removedividerandlabel./;

    Divider.prototype.doubleClick = function(event) {
      var divider_to_kill, id;
      id = jQuery(event.delegateTarget).attr('id');
      divider_to_kill = Divider.dividerByID(id);
      return divider_to_kill.kill();
    };

    Divider.dividerByID = function(id) {
      var divider, _i, _len, _ref;
      _ref = Divider.dividers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        divider = _ref[_i];
        if (divider.getHTMLAttr('id') === id) {
          return divider;
        }
      }
      return null;
    };

    Divider.sortDividers = function() {
      return Divider.dividers.sort(function(a, b) {
        return jQuery(a.html).offset().left > jQuery(b.html).offset().left;
      });
    };

    return Divider;

  })();

  LabelFactory = (function() {

    function LabelFactory() {}

    LabelFactory.addLabel = function(position) {
      return new Label(position);
    };

    return LabelFactory;

  })();

  DividerFactory = (function() {

    function DividerFactory() {}

    DividerFactory.addDivider = function(event) {
      return new Divider(event.offsetX);
    };

    return DividerFactory;

  })();

  window.timeBarMouseUp = function() {
    Divider.activeDivider = null;
    Divider.sortDividers();
    return Label.updateAll();
  };

  window.moveBarMouseMove = function(event) {
    if (Divider.activeDivider) {
      return Divider.activeDivider.setOffsetX(event.offsetX - Divider.widthHalf);
    }
  };

  jQuery(function() {
    jQuery('#time_bar').click(DividerFactory.addDivider);
    return LabelFactory.addLabel();
  });

}).call(this);
