# Doogies little extensions for JavaScript


# Remove element(s) from an array.
# returns the removed element or elements.
# http://stackoverflow.com/questions/8205710/remove-a-value-from-an-array-in-coffeescript
Array.prototype.remove = (args...) ->
  output = []
  for arg in args
    index = @indexOf arg
    output.push @splice(index, 1) if index isnt -1
  output = output[0] if args.length is 1
  output




# jQuery plugin to toggle visibility instead of css attribute "display" as the existing $.toggle() does.
jQuery::toggleVisibility = ->
  if this.css("visibility") == "hidden"
    this.css("visibility", "visible")
  else
    this.css("visibility", "hidden")
  this



###   in Javascript
      found here http://jsfiddle.net/nGhjQ/2/

(function($) {
    $.fn.makeInvisible = function() {
        return this.css("visibility", "hidden");
    };
    $.fn.makeVisible = function() {
        return this.css("visibility", "visible");
    };
})(jQuery);

###


