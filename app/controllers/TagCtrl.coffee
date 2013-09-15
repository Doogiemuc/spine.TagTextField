Spine = require('spine')
require('doogiesTools')

# Controller for a Tag. i.e. one span element inside a TagTextField
class TagCtrl extends Spine.Controller

  tag: 'span'          # type of HTML element that this controller controls

  className: 'tag'     # CSS class to set on the span element

  events:
    'mouseenter'       : 'toggleTagHighlight'
    'mouseleave'       : 'toggleTagHighlight'
    'click #deleteTag' : 'deleteTag'

  # Create a controller that handles one TagMdl instance
  # @param tagMdl: pass a TagMdl instance
  constructor: ->
    super
    @throw "param TagMdl required in TagCtrl constructor" unless @tagMdl
    @log 'new TagCtrl: '+@tagMdl.tagname
    @tagMdl.bind("update",  @render)
    @tagMdl.bind("destroy", @deleteTag)
    @render()

  # render tag with rounded borders
  render: ->
    @log "render Tag: ", @tagMdl
    @html require("views/tag")({tagname: @tagMdl.tagname})

  # add/remove highlight and show/hide delete 'X' on mouseenter/mouseleave
  toggleTagHighlight: =>
    @el.toggleClass 'mouseover'
    $(@el).children('#deleteTag').toggleVisibility()

  # called when user clicks the delete 'X'
  deleteTag: =>
    @log "deleteTag: ", @tagMdl
    @release()


module.exports = TagCtrl
