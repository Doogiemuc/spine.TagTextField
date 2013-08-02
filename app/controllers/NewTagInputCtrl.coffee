Spine = require('spine')

#-- Controller for the input field to add a new tag
class NewTagInputCtrl extends Spine.Controller
    tag:
      'input'            # create a new HTML text <input> element

    events:
      'keyup' : 'keyUp'  # cancelEdit on ESC. finishEdit on return
      #'blur'  : 'blur'   # or when user clicks outside the input elem

    # create <input type="text" class="taginput" size=5 maxlength=100>
    constructor: ->
      super
      @el.addClass 'taginput'
      @el.attr 'size', '5'
      @el.attr 'maxlength', '100'

    RETURN_KEY = 13
    ESCAPE_KEY = 27

    keyUp: (e) ->
      @trigger('finishEdit', @el.val()) if e.which == RETURN_KEY
      @trigger('cancelEdit')            if e.which == ESCAPE_KEY

    blur: ->
      @trigger('finishEdit', @el.val())
      #MAYBE:  make this configurable  and think about validation

    #TODO: auto completion from an "suggestionOracle" shown as drobdown


module.exports = NewTagInputCtrl
