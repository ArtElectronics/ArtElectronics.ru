this.ClockLoop = (function() {
  return {
    init: function() {
      return this.start_clock_loop();
    },
    start_clock_loop: function() {
      return this.loop_id = setInterval((function(_this) {
        return function() {
          var d, h, m, n, ref, s;
          d = new Date;
          n = (d.getHours()) + ":" + (d.getMinutes()) + ":" + (d.getSeconds());
          ref = n.split(':'), h = ref[0], m = ref[1], s = ref[2];
          return ClockLoop.set_clock_value(h, m, s);
        };
      })(this), 1000);
    },
    stop_clock_loop: function() {
      clearInterval(ClockLoop.loop_id);
      return delete ClockLoop.loop_id;
    },
    stop_crazy_clock_loop: function() {
      clearInterval(ClockLoop.crazy_loop_id);
      return delete ClockLoop.crazy_loop_id;
    },
    set_crazy_clock_value: function() {
      var h, m, s;
      h = __.padNum(__.randInt(0, 99));
      m = __.padNum(__.randInt(0, 99));
      s = __.padNum(__.randInt(0, 99));
      return ClockLoop.set_clock_value(h, m, s);
    },
    start_crazy_clock: function(callback) {
      ClockLoop.stop_clock_loop();
      ClockLoop.stop_crazy_clock_loop();
      ClockLoop.crazy_loop_id = setInterval(function() {
        return ClockLoop.set_crazy_clock_value();
      }, 100);
      return setTimeout(function() {
        ClockLoop.stop_crazy_clock_loop();
        return callback();
      }, 5000);
    },
    set_clock_value: function(h, m, s) {
      var a, b, number_klass, ref, ref1, ref2;
      $('@dots').toggleClass('toggle-dots');
      s = __.padNum(s);
      m = __.padNum(m);
      h = __.padNum(h);
      ref = [s[0], s[1]], a = ref[0], b = ref[1];
      number_klass = ClockLoop.getDigitKlass[a];
      $('@seconds-1').removeClass(ClockLoop.digitKlassNames);
      $('@seconds-1').addClass(number_klass);
      number_klass = ClockLoop.getDigitKlass[b];
      $('@seconds-2').removeClass(ClockLoop.digitKlassNames);
      $('@seconds-2').addClass(number_klass);
      ref1 = [m[0], m[1]], a = ref1[0], b = ref1[1];
      number_klass = ClockLoop.getDigitKlass[a];
      $('@minutes-1').removeClass(ClockLoop.digitKlassNames);
      $('@minutes-1').addClass(number_klass);
      number_klass = ClockLoop.getDigitKlass[b];
      $('@minutes-2').removeClass(ClockLoop.digitKlassNames);
      $('@minutes-2').addClass(number_klass);
      ref2 = [h[0], h[1]], a = ref2[0], b = ref2[1];
      number_klass = ClockLoop.getDigitKlass[a];
      $('@hours-1').removeClass(ClockLoop.digitKlassNames);
      $('@hours-1').addClass(number_klass);
      number_klass = ClockLoop.getDigitKlass[b];
      $('@hours-2').removeClass(ClockLoop.digitKlassNames);
      return $('@hours-2').addClass(number_klass);
    },
    digitKlassNames: 'zero one two three four five six seven eight nine',
    getDigitKlass: {
      0: 'zero',
      1: 'one',
      2: 'two',
      3: 'three',
      4: 'four',
      5: 'five',
      6: 'six',
      7: 'seven',
      8: 'eight',
      9: 'nine'
    },
    getDigitValue: {
      'zero': 0,
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9
    }
  };
})();
