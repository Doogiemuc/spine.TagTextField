Spine = require('spine')

#
# Model for a set of Tags inside a tagtextfield.
# Each Tag has a ''tagname'' and is part of one given tagtextfield, that is
# referenced via its tagtextfield_ID.
#
class TagMdl extends Spine.Model
  @configure 'TagMdl', 'tagname'

#  # get the set of tags inside one given tagtextfield
#  @getTagsByTextFieldID: (id) ->
#    @select (tagMdl) -> tagMdl.tagtextfield_ID == id

module.exports = TagMdl
