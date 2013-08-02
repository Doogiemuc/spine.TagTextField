Spine = require('spine')
require('doogiesTools')

# Controller for one Tag. i.e. one span element inside a TagTextField
class TagCtrl extends Spine.Controller
  tag:
    'span'  

  events:
    'mouseenter'      : 'toggleTagHighlight' 
    'mouseleave'      : 'toggleTagHighlight' 
    'click #deleteTag' : 'deleteTag'

  # param tagMdl: pass a TagMdl instance
  constructor: ->
    super
    @log 'new TagCtrl'
    @html require("views/tag")({tagname: @tagMdl.tagname})
  
  # add/remove highlight on mouseenter/mouseleave
  toggleTagHighlight: =>
    @el.toggleClass 'mouseover'
    # @log $(@el).children('#deleteTag')
    # $(@el).children('#deleteTag').toggleVisibility()

  deleteTag: ->
    # release()
    # TDOO: TagMdl.remove(tagname)
    
module.exports = TagCtrl