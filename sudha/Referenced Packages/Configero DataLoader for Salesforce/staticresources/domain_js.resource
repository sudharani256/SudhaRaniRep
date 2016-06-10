{
  var host = window.location.host.split('.');
  host.shift();
  document.domain = host.join('.');
}