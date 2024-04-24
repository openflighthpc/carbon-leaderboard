$(document).ready(() => {

  // username/email input
  $('#user_username').on('input', function () {
    let strUser = $(this).val();

    // input email
    if (strUser.indexOf('@') !== -1) {
      $('.icon-wrapper.user-field').css({
        '--icon-image': "url('/assets/ico/email.png')"
      });
    
    // input usernmae
    } else {
      //usernmae length limit
      if (strUser.length > 18) {
        strUser = strUser.slice(0, 18);
        $(this).val(strUser);
      }
      $('.icon-wrapper.user-field').css({
        '--icon-image': "url('/assets/ico/user.png')"
      });
    }
  });

});
