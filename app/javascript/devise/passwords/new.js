$(document).ready(() => {

  // click submit button
  $('#user_submit').click(async function () {

    const strEmail = $('#user_email').val();
    const regexEmail = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/i;

    $('#user_email').attr('placeholder', 'Email');

    // invalid email
    if (!regexEmail.test(strEmail)) {
      $('#user_email').val('');
      $('#user_email').attr('placeholder', 'Invalid username or email');

    // valid email format
    } else {
      $('#new_user').submit();
    }
  });

  // sign in/up by pressing keyboard enter
  $("#user_email, #user_submit").keydown(function (e) {
    if (e.which == 13) {
      $(this).blur();
      $("#user_submit").click();
    }
  });

});
