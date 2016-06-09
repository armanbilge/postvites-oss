# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $ ->
      $('#multiselect').multiselect()
      $('#multiselect').change(-> $('#multiselect_rightSelected').prop('disabled', $('#multiselect').val() == undefined || $('#multiselect').val().length + $('#multiselect_to option').length > invite_limit))
      if navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1
        $('#multiselect').find('option').each((i, option) ->
          $(option).data('text', $(option).text())
        )
        $("input[id^='keyword']").change( ->
          visible = new Set(_.intersection(window.attendees, $("input[id^='keyword']").map((i, k) -> if k.checked then [$(k).data('attendees')] else [window.attendees]).get()...))
          $('#multiselect').find('option').each((i, option) ->
            if visible.has(parseInt(option.value))
              $(option).prop('disabled', false)
              $(option).text($(option).data('text'))
            else
              $(option).prop('disabled', true)
              $(option).text('')
            )
        )
      else
        $("input[id^='keyword']").change( ->
          visible = new Set(_.intersection(window.attendees, $("input[id^='keyword']").map((i, k) -> if k.checked then [$(k).data('attendees')] else [window.attendees]).get()...))
          $('#multiselect').find('option').each((i, option) ->
            if visible.has(parseInt(option.value))
              $(option).show()
            else
              $(option).hide()
            )
        )

$(document).ready(ready)
$(document).on('page:load', ready)
