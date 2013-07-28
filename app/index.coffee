require('lib/setup')

Spine            = require('spine')
TagMdl           = require('models/TagMdl')
TagTextFieldCtrl = require('controllers/TagTextFieldCtrl')

class App extends Spine.Controller
  constructor: ->
    super

    # create some prefilled/dummy tags
    tagOne = new TagMdl(tagname: "TagOne")
    tagOne.save()
    tagTwo = new TagMdl(tagname: "TagTwo")
    tagTwo.save()

    #TODO: create a view for a tagtextfield
    @html require("views/storycard_demo")({dummyParam: '4711'})

    new TagTextFieldCtrl(el: $('#tagtextfield'), tagList: TagMdl.all() )

    @log 'initialized', new Date



module.exports = App
