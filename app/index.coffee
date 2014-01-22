require('lib/setup')

Spine            = require('spine')
TagInput         = require('controllers/TagInput')

class App extends Spine.Controller
  #events:
  #  'click #addOne': 'addDummyTagToModel'

  constructor: ->
    super

    # create a view for a tagtextfield
    @html require("views/storycard_demo")({dummyParam: '4711'})

    # just a dummy list of tags
    myTags = ['java', 'javascript', 'javafoobar', 'javammama', 'abc']

    # an oracle that returns a list of tagnames that match a given prefix
    # @param prefix - what the user alredy typed
    tagOracleFunc = (prefix) ->
      suggestedTag for suggestedTag in myTags when suggestedTag.indexOf(prefix) == 0

    # create an input field for tags. The existing #taginput will be replaced by the TagInput component.
    tagInput = new TagInput({
      el: $('#taginput'), 
      tags: ['abc', 'def'], 
      tagOracle: tagOracleFunc
    })

    @log 'initialized ' + new Date

module.exports = App
