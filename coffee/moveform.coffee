#
# * Moves the comments form beneath the reponding post
# * No need to include in the wordpress version
# *
#
addComment =
  moveForm: (d, f, i, c) ->
    m = this
    a = undefined
    h = m.I(d)
    b = m.I(i)
    l = m.I("cancel-comment-reply-link")
    j = m.I("comment_parent")
    k = m.I("comment_post_ID")
    return  if not h or not b or not l or not j
    m.respondId = i
    c = c or false
    unless m.I("wp-temp-form-div")
      a = document.createElement("div")
      a.id = "wp-temp-form-div"
      a.style.display = "none"
      b.parentNode.insertBefore a, b
    h.parentNode.insertBefore b, h.nextSibling
    k.value = c  if k and c
    j.value = f
    l.style.display = ""
    l.onclick = ->
      n = addComment
      e = n.I("wp-temp-form-div")
      o = n.I(n.respondId)
      return  if not e or not o
      n.I("comment_parent").value = "0"
      e.parentNode.insertBefore o, e
      e.parentNode.removeChild e
      @style.display = "none"
      @onclick = null
      false

    try
      m.I("comment").focus()
    false

  I: (a) ->
    document.getElementById a
