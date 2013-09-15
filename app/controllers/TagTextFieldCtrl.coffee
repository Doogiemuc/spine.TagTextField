Spine           = require('spine')
TagMdl          = require('models/TagMdl')
TagCtrl         = require('controllers/TagCtrl')
NewTagInputCtrl = require('controllers/NewTagInputCtrl')

###
#  Controller for a TagTextField
#  that contanis a list of [Tags|TagCtrl]
#  and may have an active [NewTagInput|NewTagInputCtrl]
#
#  This controller follows the element pattern as described here:
#  http://spinejs.com/docs/controller_patterns
###
class TagTextFieldCtrl extends Spine.Controller

  tag:       'div'
  className: 'tagtextfield'

  events:
    'dblclick' : 'startEdit'     #finishEdit is called from NewTagInputCtrl.coffee

  # private fields of this controller
  _editMode        = false
  _newTagInputCtrl = null

  # Creates a TagTextField from an HTML <div> element.
  # @param el - the tagtextfield <div> element
  constructor: ->
    super
    #MAYBE: check if a string is passed, then use it as a locator to lookup the el
    TagMdl.bind("create",  @addOneTag)
    #TagMdl.bind("refresh", @rerender)
    #TODO: TagMdl.bind("change", ????)
    @rerender()

  # append another TagMdl to the list of tags of this TagTextField
  addOneTag: (newTag) =>
    @log "addOneTag: ", newTag
    tagCtrl = new TagCtrl(tagMdl: newTag)
    @append tagCtrl

  # re-render all tags when model changes
  rerender: =>
    @log "rerendering"
    @el.empty()
    #TODO: render only tags for this textfieldID
    @append '<i class="icon-tags" style="color:#999"></i>'
    TagMdl.each(@addOneTag)

#    for aTagMdl in TagMdl.all()
#      iiTagCtrl = new TagCtrl(tagMdl: aTagMdl)
#      iiTagCtrl.bind("release", (ctrl) => ctrl.tagMdl.destroy())
#      @append iiTagCtrl


  # append an input field after the last tag
  startEdit: (e) =>
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
      _newTagInputCtrl.release()
      newTag = new TagMdl(tagname: val)
      newTag.save()   # this will trigger "create" action on TagMdl and thus call this.addOneTag
      @el.removeClass("tagtextfield_glow")
    else
      @cancelEdit()
    _editMode = false

  # callback from input field, when user presses escape
  cancelEdit: =>
    _newTagInputCtrl.release()
    @el.removeClass("tagtextfield_glow")
    _editMode = false


module.exports = TagTextFieldCtrl



###

When tag is selected
  move selection with <-  and -> keys

When in _editMode
  input.val is empty   and user pressed backspace
  select previous Tag


###
