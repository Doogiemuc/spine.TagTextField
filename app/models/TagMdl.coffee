Spine = require('spine')

# Model for a Tag that has a tagname
class TagMdl extends Spine.Model
  @configure 'TagMdl', "tagname"

  #TODO: add tagtextfieldID to be able to handle more than one tagtextfield on a page

module.exports = TagMdl
