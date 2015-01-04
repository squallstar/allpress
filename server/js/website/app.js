(function($) {
  var Website = (function() {
    var hooks = {
      'header': function($el) {
        var $html = $("html"), $window = $(window), currScrollTop = $window.scrollTop(), delta = 10;
        $window.scroll(function() {
          var newScrollTop = $window.scrollTop();
          if (newScrollTop > 2000 || (currScrollTop > 80 && newScrollTop > (currScrollTop+delta))) {
            $html.addClass('has-scrolled');
          } else if (newScrollTop < (currScrollTop-delta)) {
            $html.removeClass('has-scrolled');
          }
          currScrollTop = newScrollTop;
        });
      }
    };

    return {
      init: function() {
        for (hook in hooks) {
          var $el = $(hook);
          if ($el.length) {
            hooks[hook]($el);
          }
        }
      }
    }
  })();

  $(document).ready(Website.init);
})(jQuery);