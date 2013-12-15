require('lib/setup')

Spine            = require('spine')
TagInput         = require('controllers/TagInput')


class App extends Spine.Controller
  events:
    'click #addOne': 'addDummyTagToModel'

  constructor: ->
    super

    # create a view for a tagtextfield
    @html require("views/storycard_demo")({dummyParam: '4711'})

    # just a dummy list of tags
    myTags = ["java", "javascript", "coffeescript", "javaset"]

    # an oracle that returns a list of tagnames that match a given prefix
    # @parma prefix what the user alredy typed
    #tagOracle: (prefix) ->
    #  suggestedTag for suggestedTag in myTags when suggestedTag.indexOf(prefix) == 0

    tagInput = new TagInput(tags: myTags)
    $('#taginput').replaceWith(tagInput.el)

    @log 'initialized ' + new Date



  tagnum = 0

  addDummyTagToModel: =>
    tagnum++
    tag = new TagMdl(tagname: 'Tag'+tagnum, tagkey: 'tag'+tagnum, tagtextfield_ID: 'tagtextfield')
    tag.save()


module.exports = App
