Spine = require('spine')

#
# Model for a set of Tags inside a tagtextfield.
# @field tagname - localized name of this tag that is shown to the user
# @field tagkey  - unique key or ID of this tag
# @field tagtextfield_ID - foreign key that references the id of a tagtextfield div
#
class TagMdl extends Spine.Model
  @configure 'TagMdl', 'tagname', 'tagkey', 'tagtextfield_ID'

  # get the set of tags inside one given tagtextfield
  getByTagTextFieldID: (id) ->
    @select (tagMdl) -> tagMdl.tagtextfield_ID == id

  # get all tagnames that beginn with a given prefix
  @getByPrefix: (prefix) ->
    @select (tagMdl) ->
      tagMdl.tagname.slice(0, prefix.length) == prefix

module.exports = TagMdl
