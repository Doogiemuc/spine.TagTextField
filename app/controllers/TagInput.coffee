###
# A TagInput shows an editable list of tags. 
#
# By clicking the plus-sign, a new tag can be added.
# Optionally now tags can be autocompleted from a given list of suggestions.
# Matching suggestions are shown in a popup window below the new tag input.
#
#
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
    'click #addtagcircle' : 'startEdit'     #cancelEdit and finishEdit are called from NewTagInputCtrl
  
  elements:
    '#addtagcircle' : 'addtagcircle'

  # instance fields
  #tags = []   # list of tags
  
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
  constructor: (options)->
    if options.el
      newElem = $("<"+@tag+">")
      options.el.replaceWith newElem
      options.el = newElem
    super
    @log "new TagInput(@el="+@el.prop("tagName")+", tags=["+@tags+"])"
    @rerender()

  # update UI and re-render all tags
  rerender: =>
    @log "rerendering"
    @el.empty()
    @append '<i class="icon-tags" style="color:#999"></i>'
    tagsOrig = @tags
    @tags = []    # need to empty tags array, cause addOneTag() will fill it again
    @addOneTag tag for tag in tagsOrig
    @append '<span class="addtagcircle" id="addtagcircle">+</span>'
    
  # append another Tag to the list of tags of this TagInput
  addOneTag: (newTag) =>
    return unless newTag
    @log "addOneTag: ", newTag
    tagCtrl = new TagCtrl(tagName: newTag)
    tagCtrl.bind('deleteTag', @deleteTag)
    @tags.push(newTag)
    @append tagCtrl

  # callback from TagCtrl, when user clicks on red X to delete a Tag
  deleteTag: (tagName) =>
    @tags.remove(tagName)

  # append an input field after the last tag
  startEdit: () =>
    return if _editMode           # do not create an input twice
    _editMode = true
    @addtagcircle.remove()
    _newTagInputCtrl = new NewTagInputCtrl(tagOracle: @tagOracle)
    _newTagInputCtrl.bind('finishEdit', @finishEdit)
    _newTagInputCtrl.bind('cancelEdit', @cancelEdit)
    @append(_newTagInputCtrl)
    _newTagInputCtrl.focus()
    

  # callback from input field, when users presses return
  # we must use '=>' to find the correct 'this' context
  finishEdit: (val) =>
    _newTagInputCtrl.release()
    @tags.push(val) if val    #TODO: When is a newly entered tag valid?
    @rerender()     
    _editMode = false

  # callback from input field, when user presses escape
  cancelEdit: =>
    _newTagInputCtrl.release()
    @rerender()
    _editMode = false

#end of TagInput controller.


#----- Controller for a Tag. i.e. one span element inside a TagInput that handles deletion
class TagCtrl extends Spine.Controller

  tag: 'span'          # type of HTML element that this controller controls

  className: 'tag'     # CSS class to set on the span element

  events:
    'mouseenter'       : 'toggleDeleteTag'
    'mouseleave'       : 'toggleDeleteTag'
    'click #deleteTag' : 'deleteTag'

  # Create a <span> that shows one tag with rounded borders (and a delete-x on hover)
  # @param tagName - name of a tag as String
  constructor: ->
    super
    @throw "param 'tagName' required for TagCtrl constructor" unless @tagName
    @render()

  # render tag with rounded borders from jade template
  render: ->
    @html require("views/tag")({tagname: @tagName})

  # show/hide delete 'X' on mouseenter/mouseleave
  toggleDeleteTag: =>
    $(@el).children('#deleteTag').toggleVisibility()

  # called when user clicks the delete 'X'. Removes this tag completely.
  deleteTag: =>
    @trigger('deleteTag', @tagName)
    @release()

#end of TagCtrl

#----- Controller for the input field to add a new tag
class NewTagInputCtrl extends Spine.Controller

    tag:       'span'        # wrapper for input field and tagOracle

    className: 'newtaginput'

    elements:  
      'input'     : 'inputElem'
      '#tagOracle' : 'tagOracleElem'  # the little popup below the input

    events:
      'keyup' : 'keyUp'      # cancelEdit on ESC. finishEdit on return
      'blur'  : 'blur'       # or when user clicks outside the input elem
      'input input' : 'inputValChanged' # listen to value changes in the <input> field via the modern 'input' event

    # instance properties
    tagOracleShown          : false  # if more than two letters are entered, show popup with possible autocompletions
    selectedSuggestionIdx   : -1     # index of the currently selected suggestion (-1 = none selected)
    
    # Constants for key coces
    RETURN_KEY    = 13
    ESCAPE_KEY    = 27
    MOVE_UP       = 38
    MOVE_DOWN     = 40

    # create an <input> field for a new tag (will be wraped in a span)
    #  @param tagOracle - a function that returns autocompletion suggestions when passed a prefix string
    constructor: ->
      super
      @append '<input type="text" size=5 maxlength=100>'
      @append '<span id="tagOracle">content</span>'
      @log "NewTagInputCtrl appended"
      
    # set focus to the <input> elem
    focus: ->
      @inputElem.focus()
    
    # dispatch keypress and update suggestin popup
    keyUp: (e) =>
      switch e.which
        when RETURN_KEY
          val = @selectedSuggestionIdx >= 0 ? @matchingSuggestions[@selectedSuggestionIdx] : @inputElem.val()
          @trigger('finishEdit', val)
        when ESCAPE_KEY
          @trigger('cancelEdit')
        when MOVE_UP
          if @tagOracleShown and @selectedSuggestionIdx > 0
            @selectedSuggestionIdx--
            @rerenderOracle()
        when MOVE_DOWN
          # TODO: only open tagOracleSpan if a tagOracle function was passed
          if @tagOracleShown and @selectedSuggestionIdx < @matchingSuggestions.length-1
            @selectedSuggestionIdx++
            @rerenderOracle()
            
      @log "KEYUP: selectedSuggestionIdx="+@selectedSuggestionIdx
 
    rerenderOracle: =>
      @log "rerenderOracle(idx="+@selectedSuggestionIdx+")"
      if @inputElem.val().length <= 2
        @tagOracleElem.hide()
        @tagOracleShown = false
        @log "hiding oracle"
        return
      @matchingSuggestions = @tagOracle(@inputElem.val())
      if @matchingSuggestions.length == 0
        @tagOracleElem.hide()
        return
      @selectedSuggestionIdx = Math.min(@selectedSuggestionIdx, @matchingSuggestions.length-1)
      
      @tagOracleElem.replaceWith require("views/tagOracle")({
        suggestions:          @matchingSuggestions, 
        selectedSuggestionIdx: @selectedSuggestionIdx
      })
      @refreshElements()
      @tagOracleElem.show
      @tagOracleShown = true
             

    # when value of <input> field changes, then update the matching suggestions and rerender the oracle
    inputValChanged: =>
      @matchingSuggestions = @tagOracle @inputElem.val()
      @log "inputValChanged to '" + @inputElem.val()+"', matchingSugs="+@matchingSuggestions
      @rerenderOracle()
      return
      if @inputElem.val().length > 2
        if @tagOracleShown 
          # update suggestions in already shown tagOracle
          @log "updating oracle idx="+@selectedSuggestionIdx
          $("#tagOracle").replaceWith @getOracleView()
        else
          # open tagOracle
          @log "showing oracle with suggestions="+@matchingSuggestions
          @append @getOracleView()
          @tagOracleShown = true
      else
        if @tagOracleShown
          # remove tagOracleView
          $("#tagOracle").remove
          @tagOracleShown = false   
    
    # create a popup window showing the list of matching tags
    getOracleView: ->
      #TODO: show matching part in bold in suggestion texts  (regex? need to prevent escapeing in jade template then)
      oracleView = require("views/tagOracle")({
        suggestions:           @matchingSuggestions,     
        selectedSuggestionIdx: @selectedSuggestionIdx
      })

    blur: ->
      #@trigger('finishEdit', @el.val())
      #MAYBE:  make this configurable  and think about validation

#end of class NewTagInputCtrl



module.exports = TagInput



###

More ideas:

When tag is selected
  move selection with <-  and -> keys

When in _editMode
  input.val is empty   and user pressed backspace
  select previous Tag


###
