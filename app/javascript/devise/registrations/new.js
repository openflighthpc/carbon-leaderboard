$(document).ready(() => {

  // click submit button
  $('#user_submit').click(async function () {

    let validData = true;
    const strEmail = $('#user_email').val();
    const strUsername = $('#user_username').val();
    const strPassword = $('#user_password').val();
    const regexNotUsername = /\W/;
    const regexEmail = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/i;

    $('#user_email').attr('placeholder', 'Email');
    $('#user_username').attr('placeholder', 'Username');
    $('#user_password').attr('placeholder', 'Password');
    
    // invalid email
    if (!regexEmail.test(strEmail)) {
      $('#user_email').val('');
      $('#user_email').attr('placeholder', 'Invalid email');
      validData = false;
    }

    // invalid username
    if (regexNotUsername.test(strUsername)) {
      $('#user_username').val('');
      $('#user_username').attr('placeholder', 'Invalid username');
      validData = false;
    } else if (strUsername.length < 4) {
      $('#user_username').val('');
      $('#user_username').attr('placeholder', 'Minimum 4 characters');
      validData = false;
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
    } else if (response.status === 409) {
      const {email_msg, username_msg} = await response.json();
      if (email_msg !== undefined) {
        $('#user_email').val('');
        $('#user_email').attr('placeholder', email_msg);
      }
      if (username_msg !== undefined) {
        $('#user_username').val('');
        $('#user_username').attr('placeholder', username_msg);
      }
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