$('#videos').fitVids()

$('#new_video').on 'submit', (e) ->
  e.preventDefault()

  $form = $(this)

  $.ajax
    type: 'POST'
    url: $form.attr('action')
    data: $form.serialize()
    success: (video) ->
      $form.get(0).reset()

      $('#videos')
        .prepend("<article>#{video.html}</article>")
        .fitVids()
