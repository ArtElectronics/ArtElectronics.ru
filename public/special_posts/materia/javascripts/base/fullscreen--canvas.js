this.FullScreen = (function() {
  return {
    size_fit: function() {
      var win_h, win_w;
      this.win || (this.win = $(window));
      this.doc || (this.doc = $(document));
      this.body || (this.body = $('body'));
      win_w = this.win.outerWidth(true);
      win_h = this.win.outerHeight(true);
      return $('@fullscreen--canvas').css({
        'height': win_h,
        'width': win_w,
        'min-height': win_h,
        'min-width': win_w
      });
    }
  };
})();
