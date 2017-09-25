function getLoggedData (callback) {
  var req = new XMLHttpRequest();
  req.addEventListener('load', function () {
    var loggedUser = JSON.parse(this.responseText);
    if (loggedUser.service_id) {
      return callback(loggedUser, true);
    } else {
      return callback(null, false);
    }
  });
  req.open('GET', location.origin + '/unvx-api/users/logged');
  req.send();
}

function startJS () {
  // Common call for all pages.
  var bLazy = new Blazy({
    offset: 250,
    src: 'lazy-src'
  });
  var links = document.querySelector('link');
  var fontAwesome = document.createElement('link');
  var animate = document.createElement('link');
  var animateExt = document.createElement('link');
  var fontLato = document.createElement('link');
  var selector = document.querySelector('#unvx-user span');
  
  fontAwesome.rel = 'stylesheet';
  animate.rel = 'stylesheet';
  animateExt.rel = 'stylesheet';
  fontLato.rel = 'stylesheet';
  
  fontAwesome.href = location.origin + '/styles/font-awesome-min.css';
  animate.href = location.origin + '/styles/animate-min.css';
  animateExt.href = location.origin + '/styles/animate-ext.css';
  fontLato.href = 'https://fonts.googleapis.com/css?family=Lato:300,400,700';

  fontAwesome.type = 'text/css';
  animate.type = 'text/css';
  animateExt.type = 'text/css';
  fontLato.type = 'text/css';
  
  links.parentNode.appendChild(fontAwesome);
  links.parentNode.appendChild(animate);
  links.parentNode.appendChild(animateExt);
  links.parentNode.appendChild(fontLato);

  getLoggedData (function (loggedUser, exists) {
    if (exists) {
      selector.innerHTML = loggedUser.username;
      selector.parentNode.href = '#logout-modal';
    }
  });
  // Optional calls for specific pages.
  if (typeof startJSSignup === 'function') {
    startJSSignup();
  }
}

window.onload = function () {
  startJS();
};