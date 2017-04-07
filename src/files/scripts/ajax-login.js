function startJSLogin () {
  isLogged(function (result) {
    // Get page content
    var destHTMLObj = document.querySelector('.unvx-login .content');
    var btnArea = destHTMLObj.querySelector('.unvx-btn-area');
    var msgObj;
    if (result) {
      // Message part.
      msgObj = destHTMLObj.querySelector('p');
      msgObj.innerHTML = 'Ya has iniciado sesión. No hace falta que estés aquí.';

      // Button area part.
      var backBtn = document.createElement('a');
      var spanBackBtn = document.createElement('span');
      spanBackBtn.innerHTML = 'Volver';
      backBtn.appendChild(spanBackBtn);
      backBtn.setAttribute('href', location.origin + '/');
      backBtn.classList.add('pure-button', 'pure-button-primary');

      var logoutBtn = document.createElement('a');
      var spanLogoutBtn = document.createElement('span');
      spanLogoutBtn.innerHTML = 'Cerrar sesión';
      logoutBtn.appendChild(spanLogoutBtn);
      logoutBtn.setAttribute('href', location.origin + '/logout');
      logoutBtn.classList.add('pure-button');

      btnArea.appendChild(backBtn);
      btnArea.appendChild(logoutBtn);
    } else {
      // Message part.
      msgObj = destHTMLObj.querySelector('p');
      msgObj.innerHTML = 'Elija cómo entrar en UnivUnix:';

      // Button area part.
      var githubBtn = document.createElement('a');
      var iGithubBtn = document.createElement('i');
      var spanGithubBtn = document.createElement('span');
      iGithubBtn.classList.add('fa', 'fa-fw', 'fa-github');
      iGithubBtn.setAttribute('aria-hidden', 'true');
      spanGithubBtn.innerHTML = 'Github';
      githubBtn.appendChild(iGithubBtn);
      githubBtn.appendChild(spanGithubBtn);
      githubBtn.setAttribute('href', location.origin + '/auth/github');
      githubBtn.classList.add('pure-button', 'btn-github');

      var googleBtn = document.createElement('a');
      var iGoogleBtn = document.createElement('i');
      var spanGoogleBtn = document.createElement('span');
      iGoogleBtn.classList.add('fa', 'fa-fw', 'fa-google');
      iGoogleBtn.setAttribute('aria-hidden', 'true');
      spanGoogleBtn.innerHTML = 'Google';
      googleBtn.appendChild(iGoogleBtn);
      googleBtn.appendChild(spanGoogleBtn);
      googleBtn.setAttribute('href', location.origin + '/auth/google');
      googleBtn.classList.add('pure-button', 'btn-google');

      btnArea.appendChild(githubBtn);
      btnArea.appendChild(googleBtn);
    }
  });
}
