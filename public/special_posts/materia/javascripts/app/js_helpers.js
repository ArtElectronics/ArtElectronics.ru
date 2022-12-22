this.__ = (function() {
  return {
    to_i: function(num) {
      return parseInt(num, 10);
    },
    randInt: function(min, max) {
      var rand;
      if (min == null) {
        min = 0;
      }
      if (max == null) {
        max = 10;
      }
      rand = min - 0.5 + Math.random() * (max - min + 1);
      return Math.round(rand);
    },
    padNum: function(num) {
      if ((num = num + '').length === 1) {
        return "0" + num;
      } else {
        return num;
      }
    },
    ary_diff: function(a, b) {
      return a.filter(function(i) {
        return b.indexOf(i) < 0;
      });
    }
  };
})();
