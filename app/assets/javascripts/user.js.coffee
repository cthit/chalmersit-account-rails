$ ->
  $('.edit_ldap_user').on 'input', '#ldap_user_gn, #ldap_user_sn, #ldap_user_nickname', replaceDisplayName

  replaceDisplayName()

replaceDisplayName = ->
  gn = $('#ldap_user_gn').val()
  sn = $('#ldap_user_sn').val()
  nickname = $('#ldap_user_nickname').val()
  $('#ldap_user_cn option').each ->
    $(this).text $(this).val().replace('%{firstname}', gn).replace('%{lastname}', sn).replace('%{nickname}', nickname)
