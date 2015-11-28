# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    $ ->
        $('#multiselect').multiselect()
        $('#multiselect').change(-> $('#multiselect_rightSelected').prop('disabled', $('#multiselect').val() == undefined || $('#multiselect').val().length + $('#multiselect_to option').length > invite_limit))

$(document).ready(ready)
$(document).on('page:load', ready)
