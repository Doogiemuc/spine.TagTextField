Spine           = require('spine')
TagMdl          = require('models/TagMdl')
TagCtrl         = require('controllers/TagCtrl')
NewTagInputCtrl  = require('controllers/NewTagInputCtrl')

###
  Controller for a TagTextField 
  that contanis a list of [Tags|TagCtrl]
  and may have an active [TagInput|TagInputCtrl]
###
class TagTextFieldCtrl extends Spine.Controller
  events:
    # 'mouseenter .tag': 'toggleHighlight'
    # 'mouseleave .tag': 'toggleHighlight'
    'dblclick'       : 'startEdit'

  editMode        = false
  newTagInputCtrl = null
  # @taglist         = []

  # This constructor expects a two parameters
  # el:      the tagtextfield div
  # tagList: a list of TagMdls (may be empty)
  constructor: ->
    super
    @log "new TagTextFieldCtrl tagList=", @tagList
    TagMdl.bind("refresh change", @rerender)
    @rerender()

  # re-render all tags when model changes
  rerender: =>
    @log "rerendering ", @tagList
    @el.empty()
    # TODO: render only tags for this textfieldID
    @append '<i class="icon-tags" style="color:#999"></i>MMM'
    for aTagMdl in @tagList
      @append new TagCtrl(tagMdl: aTagMdl)


  # append an input field after the last tag
  startEdit: (e) =>
    return if editMode           # do not create an input twice
    editMode = true
    @el.addClass("tagtextfield_glow")
    taginputID = '#taginputID_47'
    newTagInputCtrl = new NewTagInputCtrl
    newTagInputCtrl.bind('finishEdit', @finishEdit)
    newTagInputCtrl.bind('cancelEdit', @cancelEdit)
    @append(newTagInputCtrl)
    newTagInputCtrl.el.focus()

  # callbacak from input field, when users presses return
  # we must use '=>' to find the correct 'this' context,
  # ie. this TagaCtrl class
  finishEdit: (val) =>
    if val
      newTag = new TagMdl(tagname: val)
      @tagList.push(newTag) # TODO: Rerender should know what to render
      newTag.save()
      @el.removeClass("tagtextfield_glow")
    else
      @cancelEdit()
    editMode = false

  # callback from input field, when user presses escape
  cancelEdit: =>
    newTagInputCtrl.release()
    @el.removeClass("tagtextfield_glow")
    editMode = false


module.exports = TagTextFieldCtrl



###

When tag is selected
  move selection with <-  and -> keys

When in editMode
  input.val is empty   and user pressed backspace
  select previous Tag


###
