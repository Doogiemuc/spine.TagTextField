Spine           = require('spine')
TagMdl          = require('models/TagMdl')
NewTagInputCtrl = require('controllers/NewTagInputCtrl')
require('doogiesTools')

#-- Controller for a TagTextField that contanis Tags
class TagCtrl extends Spine.Controller
  elements:         #child elements of id="tagtextfield"
    '.tag' : 'tagElements'

  events:
    'mouseenter .tag': 'toggleHighlight'
    'mouseleave .tag': 'toggleHighlight'
    'dblclick'       : 'startEdit'

  editMode        = false
  newTagInputCtrl = null
  # @taglist         = []

  # This constructor expects two parameteres:
  # el:      the tagtextfield div
  # taglist: a list of TagMdls (may be empty)
  constructor: ->
    super
    TagMdl.bind("refresh change", @rerender)
    @rerender()

  # add/remove highlight on mouseenter/mouseleave
  toggleHighlight: (e) ->
    $(e.currentTarget).toggleClass 'mouseover'

    elem = $(e.currentTarget).children(".tagDelete")
    # @log e.currentTarget, elem[0]
    elem.toggleVisibility()


  # re-render all tags when model changes
  rerender: =>
    @el.empty()
    #TODO: render only tags for this textfieldID
    for tagMdl in @tagList
      @append require("views/tag")({tagname: tagMdl.tagname})

  # append an input field after the last tag
  startEdit: (e) ->
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
      @tagList.push(newTag) #TODO: Rerender should know what to render
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


module.exports = TagCtrl



###

When tag is selected
  move selection with <-  and -> keys

When in editMode
  input.val is empty   and user pressed backspace
  select previous Tag


###
