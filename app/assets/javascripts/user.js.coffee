$(document).on 'page:change', ->
  $('.edit_ldap_user').on 'input', '#ldap_user_gn, #ldap_user_sn, #ldap_user_nickname', replaceDisplayName
  $('.edit_ldap_user').on 'input', '#ldap_user_push_services_pushover_api, #ldap_user_push_services_pushbullet_api', setRadioBoxesEnabled

  replaceDisplayName()
  setRadioBoxesEnabled()

replaceDisplayName = ->
  gn = $('#ldap_user_gn').val()
  sn = $('#ldap_user_sn').val()
  nickname = $('#ldap_user_nickname').val()
  $('#ldap_user_cn option').each ->
    $(this).text $(this).val().replace('%{firstname}', gn).replace('%{lastname}', sn).replace('%{nickname}', nickname)

setRadioBoxesEnabled = ->
  services = ['pushover', 'pushbullet']
  $(services).each ->
    apibox = $("#ldap_user_push_services_#{this}_api")

