# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $ ->
      $('#multiselect').multiselect()
      $('#multiselect').unbind('dblclick')
      $('#multiselect_to').unbind('dblclick')
      $('option').each((i, option) ->
        $(option).dblclick((e) ->
          if $.inArray(option, $('#multiselect_to').find('option')) != -1
            $('#modalBody\\[' + $(option).val() + '\\]').html('<iframe frameBorder="0" style="width:100%" height="270px" src="/invitations/' + window.presenter_secret + '/' + $(option).val() + '"></iframe>')
            $('#message\\[' + $(option).val() + '\\]').modal('show')
        )
      )
      $('#multiselect').change(-> $('#multiselect_rightSelected').prop('disabled', $('#multiselect').val() == undefined || $('#multiselect').val().length + $('#multiselect_to option').length > window.invite_limit))
      if navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1
        $("input[id^='keyword']").change( ->
          visible = new Set(_.intersection(window.attendees, $("input[id^='keyword']").map((i, k) -> if k.checked then [$(k).data('attendees')] else [window.attendees]).get()...))
          $('#multiselect').children().each((i, option) ->
            if $(option).prop('tagName') != 'OPTION'
              if visible.has(parseInt($(option).attr('value')))
                x = $('<option>' + option.innerHTML + '</option>')
                x.attr('value', $(option).attr('value'))
                $(option).replaceWith(x);
            else
              if !visible.has(parseInt(option.value))
                x = $('<div>' + option.innerHTML + '</div>')
                x.attr('value', $(option).attr('value'))
                $(option).replaceWith(x);
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
