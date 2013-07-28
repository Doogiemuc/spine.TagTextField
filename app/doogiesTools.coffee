

###   in Javascript
      found here

(function($) {
    $.fn.makeInvisible = function() {
        return this.css("visibility", "hidden");
    };
    $.fn.makeVisible = function() {
        return this.css("visibility", "visible");
    };
})(jQuery);

###


# jQuery plugin to toggle visibility instead of css attribute "display" as the existing $.toggle() does.
jQuery::toggleVisibility = ->
  if this.css("visibility") == "hidden"
    this.css("visibility", "visible")
  else
    this.css("visibility", "hidden")
  this



