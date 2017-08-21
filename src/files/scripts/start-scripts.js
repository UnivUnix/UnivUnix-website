function startJS () {
  // Common call for all pages.
  startJSCommon();
  // Optional calls for specific pages.
  if (typeof startJSLogin === 'function') {
    startJSLogin();
  }
  if (typeof startJSSignup === 'function') {
    startJSSignup();
  }
}

window.onload = function () {
  var bLazy = new Blazy({
    offset: 250,
    src: 'lazy-src'
  });

  var links = document.querySelector('link');
  var fontAwesome = document.createElement('link');
  fontAwesome.rel = 'stylesheet';
  fontAwesome.href = location.origin + '/styles/font-awesome-min.css';
  fontAwesome.type = 'text/css';
  links.parentNode.appendChild(fontAwesome);

  var fontLato = document.createElement('link');
  fontLato.rel = 'stylesheet';
  fontLato.href = 'https://fonts.googleapis.com/css?family=Lato:300,400,700';
  fontLato.type = 'text/css';
  links.parentNode.appendChild(fontLato);

  startJS();
};
