this.ArticleIndex = ['Идеальное состояние мыслящеи материи.html', 'Информационное поле планеты.html', 'Киборги будущего.html', 'Клоны и генетически измененные люди.html', 'Когда люди перестанут быть людьми.html', 'Люди, зараженные программируемыми вирусами.html', 'Люди_и_древние_рыбы._От_ненормальности_к_ново.html', 'Нашествие_роботов.html', 'Определение мыслящеи материи.html', 'Потомок человечества.html', 'Развитие мысли вместо эволюции.html', 'Цели мыслящеи материи.html', 'Человек между мыслью и жизнью.html', 'Человек перестает быть живым существом.html', 'Электронныи рабочии.html'];

this.ArticleControls = (function() {
  return {
    Index: 0,
    ViewedPages: [],
    visibility: function() {
      var index, next, prev;
      index = ArticleControls.Index;
      prev = $('.slide-controls--prev');
      if (ArticleControls.ViewedPages[index - 1]) {
        prev.show();
      } else {
        prev.hide();
      }
      next = $('.slide-controls--next');
      if (ArticleControls.ViewedPages[index + 1]) {
        return next.show();
      } else {
        return next.hide();
      }
    },
    go_with_index: function(slide) {
      var index, slide_id;
      slide_id = slide.data('slide-id');
      index = ArticleControls.ViewedPages.indexOf(slide_id);
      if (index === -1) {
        ArticleControls.ViewedPages.push(slide_id);
        index = ArticleControls.ViewedPages.indexOf(slide_id);
      }
      ArticleControls.Index = index;
      log(index);
      ArticleControls.visibility();
      return ArticleControls.go_to(slide);
    },
    go_to: function(slide) {
      return $("html, body").animate({
        scrollTop: slide.offset().top,
        scrollLeft: slide.offset().left
      }, 1000);
    },
    init: function() {
      $('@article-repeat').on('click', function(e) {
        var slide;
        slide = $("[data-slide-id='index']");
        return ArticleControls.go_to(slide);
      });
      $('@article-prev').on('click', function(e) {
        var btn, new_slide, slide;
        btn = $(e.currentTarget);
        new_slide = ArticleControls.ViewedPages[ArticleControls.Index - 1];
        slide = $("[data-slide-id='" + new_slide + "']");
        log(new_slide);
        return ArticleControls.go_with_index(slide);
      });
      return $('@article-next').on('click', function(e) {
        var btn, new_slide, slide;
        btn = $(e.currentTarget);
        new_slide = ArticleControls.ViewedPages[ArticleControls.Index + 1];
        slide = $("[data-slide-id='" + new_slide + "']");
        log(new_slide);
        return ArticleControls.go_with_index(slide);
      });
    }
  };
})();

this.ActionMarkers = {
  timer_started: false
};

this.LinkChecker = (function() {
  return {
    init: function() {
      return $('a').each(function(a, b) {
        var href, link;
        link = $(b);
        href = link.attr('href');
        if (ArticleIndex.indexOf(href) === -1) {
          link.attr('href', '#');
          return link.addClass('no-actual-link');
        }
      });
    }
  };
})();

this.ContentBlockSize = (function() {
  return {
    init: function() {
      var win_h;
      win_h = __.to_i($(window).outerHeight(true) * 0.7);
      return $('.nano').attr('style', "height: " + win_h + "px !important");
    }
  };
})();

$(function() {
  var slide;
  ClockLoop.init();
  FullScreen.size_fit();
  ArticleControls.init();
  LinkChecker.init();
  ContentBlockSize.init();
  ArticleControls.visibility();
  slide = $("[data-slide-id='index']");
  ArticleControls.go_to(slide);
  $(".nano").nanoScroller({
    alwaysVisible: true
  });
  $('.bg-dark--info').on('click', function() {
    slide = $("[data-slide-id='info.html']");
    return ArticleControls.go_to(slide);
  });
  $('a').click(function(e) {
    var slide_id;
    slide_id = $(e.currentTarget).attr('href');
    slide = $("[data-slide-id='" + slide_id + "']");
    if (slide.length === 0) {
      return false;
    }
    ArticleControls.go_with_index(slide);
    return false;
  });
  $('@story-generator').on('click', function() {
    var callback;
    log(ActionMarkers.timer_started);
    if (ActionMarkers.timer_started) {
      return;
    }
    ActionMarkers.timer_started = true;
    callback = function() {
      var ary_diff, div_value, h1, h2, m1, m2, new_slide, s1, s2, slide_index, v1, v2, v3;
      h1 = $('@hours-1').attr('class');
      h2 = $('@hours-2').attr('class');
      h1 = ClockLoop.getDigitValue[h1];
      h2 = ClockLoop.getDigitValue[h2];
      m1 = $('@minutes-1').attr('class');
      m2 = $('@minutes-2').attr('class');
      m1 = ClockLoop.getDigitValue[m1];
      m2 = ClockLoop.getDigitValue[m2];
      s1 = $('@seconds-1').attr('class');
      s2 = $('@seconds-2').attr('class');
      s1 = ClockLoop.getDigitValue[s1];
      s2 = ClockLoop.getDigitValue[s2];
      log(v1 = __.to_i("" + h1 + h2));
      log(v2 = __.to_i("" + m1 + m2));
      log(v3 = __.to_i("" + s1 + s2));
      ary_diff = __.ary_diff(ArticleIndex, ArticleControls.ViewedPages);
      if (ary_diff.length === 0) {
        ary_diff = ArticleIndex;
      }
      div_value = ary_diff.length;
      slide_index = (v1 + v2 + v3) % div_value;
      new_slide = ary_diff[slide_index];
      log("==> " + new_slide);
      slide = $("[data-slide-id='" + new_slide + "']");
      return setTimeout(function() {
        ArticleControls.go_with_index(slide);
        ClockLoop.init();
        return ActionMarkers.timer_started = false;
      }, 500);
    };
    return ClockLoop.start_crazy_clock(callback);
  });
  return log('Canvas resized to full screen');
});
