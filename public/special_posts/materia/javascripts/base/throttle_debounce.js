this.debounce = function(func, wait, immediate) {
  var result, timeout;
  timeout = void 0;
  result = void 0;
  return function() {
    var args, callNow, context, later;
    context = this;
    args = arguments;
    later = function() {
      timeout = null;
      if (!immediate) {
        result = func.apply(context, args);
      }
      return true;
    };
    callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) {
      result = func.apply(context, args);
    }
    return result;
  };
};

this.throttle = function(func, wait) {
  var args, context, later, previous, result, timeout;
  previous = 0;
  context = void 0;
  args = void 0;
  timeout = void 0;
  result = void 0;
  later = function() {
    timeout = null;
    previous = new Date;
    result = func.apply(context, args);
    return true;
  };
  return function() {
    var now, remaining;
    now = new Date;
    remaining = wait - (now - previous);
    context = this;
    args = arguments;
    if (remaining <= 0) {
      clearTimeout(timeout);
      timeout = null;
      previous = now;
      result = func.apply(context, args);
    } else {
      if (!timeout) {
        timeout = setTimeout(later, remaining);
      }
    }
    return result;
  };
};
