$(document).ready(() => {

  // username/email input detection
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

  // click submit button
  $('#user_submit').click(async function () {

    let validData = true;
    const strUser = $('#user_username').val();
    const strPassword = $('#user_password').val();
    const regexNotUsername = /\W/;
    const regexEmail = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/i;

    $('#user_username').attr('placeholder', 'Username or email');
    $('#user_password').attr('placeholder', 'Password');

    // invalid username
    if (!regexEmail.test(strUser) && regexNotUsername.test(strUser)) {
      $('#user_username').val('');
      $('#user_username').attr('placeholder', 'Invalid username or email');
      validData = false;

    // login by username
    } else if (!regexNotUsername.test(strUser)) {
      // username too short
      if (strUser.length < 4) {
        $('#user_username').val('');
        $('#user_username').attr('placeholder', 'Minimum 4 characters');
        validData = false;
      }
    }

    // password too short
    if (strPassword.length < 6) {
      $('#user_password').val('');
      $('#user_password').attr('placeholder', 'Minimum 6 characters');
      validData = false;
    }

    // submit the form
    if (validData) {
      $('#new_user').submit();
    }
  });

  $('#new_user').on('submit', async function (e) {
    e.preventDefault();
    const response = await fetch(e.currentTarget.action, {
      method: e.currentTarget.method,
      body: new FormData(e.currentTarget)
    });
    
    if (response.status === 303) {
      const {location} = await response.json();
      window.location.href = location;
    } else if (response.status === 401) {
      const {msg} = await response.json();
      $('#user_password').val('');
      $('#user_password').attr('placeholder', msg);
    }
  });

  // sign in/up by pressing keyboard enter
  $("#user_password, #user_submit").keydown(function (e) {
    if (e.which == 13) {
      $(this).blur();
      $("#user_submit").click();
    }
  });

});
