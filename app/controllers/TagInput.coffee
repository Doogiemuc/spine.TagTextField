###
# A TagInput shows an editable list of tags. On double click a new input is shown
# where a new tag can be entered. On mouseover a red cross is shown,
# where this tag can be deleted.
#
# Usage:
# <code>new TagInput(tags: ['optional', 'list', 'of', 'tags'])</code>
###

Spine        = require('spine')
require('doogiesTools')

#----- Spine controller for a tag input field that contanis a list of Tags.
class TagInput extends Spine.Controller
  tag:       'span'
  className: 'taginput'

  events:
    'dblclick' : 'startEdit'     #cancelEdit and finishEdit are called from NewTagInputCtrl

  # private fields
  _editMode        = false
  _newTagInputCtrl = null

  # Creates a TagInput by replacing an HTML element.
  # Params are passed as one associative array with the keys:
  # {
  #  el        - an HTML <input> element, that will be replaced by this TagInput
  #  tagOrcale - a function that returns tag suggestions (list of strings), when passed a prefix (string)
  #  tags      - list of inital Tags
  # }
  constructor: ->
    super
    @log "new TagInput("+@tags+")"
    @rerender()

  # update UI and re-render all tags
  rerender: =>
    @log "rerendering"
    @el.empty()
    @append '<i class="icon-tags" style="color:#999"></i>'
    @addOneTag tag for tag in @tags

  # append another Tag to the list of tags of this TagInput
  addOneTag: (newTag) =>
    return unless newTag
    @log "addOneTag: ", newTag
    tagCtrl = new TagCtrl(tagName: newTag)
    tagCtrl.bind('deleteTag', @deleteTag)
    @tags.push(newTag)
    @append tagCtrl

  # called from TagCtrl, when user clicks on red X to delete a Tag
  deleteTag: (tagName) =>
    @tags.remove(tagName)

  # append an input field after the last tag
  startEdit: () =>
    return if _editMode           # do not create an input twice
    _editMode = true
    @el.addClass("tagtextfield_glow")
    _newTagInputCtrl = new NewTagInputCtrl()
    _newTagInputCtrl.bind('finishEdit', @finishEdit)
    _newTagInputCtrl.bind('cancelEdit', @cancelEdit)
    @append(_newTagInputCtrl)
    _newTagInputCtrl.el.focus()

  # callback from input field, when users presses return
  # we must use '=>' to find the correct 'this' context
  finishEdit: (val) =>
    if val
      @el.removeClass("tagtextfield_glow")
      _newTagInputCtrl.release()
      @addOneTag(val)
    else
      @cancelEdit()
    _editMode = false

  # callback from input field, when user presses escape
  cancelEdit: =>
    _newTagInputCtrl.release()
    @el.removeClass("tagtextfield_glow")
    _editMode = false

#end of TagInput controller.


#----- Controller for a Tag. i.e. one span element inside a TagInput
class TagCtrl extends Spine.Controller

  tag: 'span'          # type of HTML element that this controller controls

  className: 'tag'     # CSS class to set on the span element

  events:
    'mouseenter'       : 'toggleTagHighlight'
    'mouseleave'       : 'toggleTagHighlight'
    'click #deleteTag' : 'deleteTag'

  # @param tagName: name of a tag as String
  constructor: ->
    super
    @throw "param 'tagName' required for TagCtrl constructor" unless @tagName
    @render()

  # render tag with rounded borders from jade template
  render: ->
    @html require("views/tag")({tagname: @tagName})

  # add/remove highlight and show/hide delete 'X' on mouseenter/mouseleave
  toggleTagHighlight: =>
    @el.toggleClass 'mouseover'
    $(@el).children('#deleteTag').toggleVisibility()


  # called when user clicks the delete 'X'. Removes this tag completely.
  deleteTag: =>
    @trigger('deleteTag', @tagName)
    @release()

#end of TagCtrl

#----- Controller for the input field to add a new tag
class NewTagInputCtrl extends Spine.Controller

    # <input type="text" class="taginput" size=5 maxlength=100>
    tag:
      'input'            # create a new HTML text <input> element

    className:
      'newtag'

    attributes:
      'size'      : 5
      'maxlength' : 100

    events:
      'keyup' : 'keyUp'  # cancelEdit on ESC. finishEdit on return
      'blur'  : 'blur'   # or when user clicks outside the input elem

    RETURN_KEY = 13
    ESCAPE_KEY = 27

    keyUp: (e) =>
      @trigger('finishEdit', @el.val()) if e.which == RETURN_KEY
      @trigger('cancelEdit')            if e.which == ESCAPE_KEY
      if @el.val().length > 2
        @el.append new TagOracleCtrl(suggestions: ['suggest1', 'suggest2'])

    blur: ->
      @trigger('finishEdit', @el.val())
      #MAYBE:  make this configurable  and think about validation


#end of class NewTagInputCtrl

#----- a popup that shows a list of autocompletion suggestions for the entered prefix string
class TagOracleCtrl extends Spine.Controller
    tag:       'ul'
    className: 'tagoracle'

    _selected = 0    # selected list items

    constructor: ->
      super
      if not @suggestions
        @log "Must have suggestions in TagOracleCtrl"
      @el.append('<li>Test</li>')
      @el.append('<li>Test2</li>')

    setSuggestions: ->
      @el.append('<li class="tagOracleItem">'+suggestion+'</li>') for suggestion in @suggestions
      true

#end of class TagOracleCtrl



module.exports = TagInput



###

More ideas:

When tag is selected
  move selection with <-  and -> keys

When in _editMode
  input.val is empty   and user pressed backspace
  select previous Tag


###
