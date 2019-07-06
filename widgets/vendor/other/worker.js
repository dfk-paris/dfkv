var data = null;

var init = function(argument) {
  var h = function() {
    data = JSON.parse(this.responseText);
    console.log(data);
    postMessage({type: 'ready'});
  }

  var r = new XMLHttpRequest();
  r.addEventListener("load", h);
  r.open("GET", "data.json");
  r.send();
}

var folds = {
  'ä': 'a',
  'ö': 'o',
  'ü': 'u',
  'ß': 's',
  'ê': 'e',
  'è': 'e',
  'é': 'e',
  'ë': 'e',
  'ç': 'c',
  'â': 'a',
  'á': 'a',
  'à': 'a',
  'î': 'i',
  'í': 'i',
  'ì': 'i',
  'ï': 'i',
  'ô': 'o',
  'ó': 'o',
  'ò': 'o',
  'û': 'u',
  'ú': 'u',
  'ù': 'u',
  'æ': 'ae'
}

var fold = function(str) {
  var chars = Object.keys(folds).join();
  var regex = new RegExp('[' + chars + ']', 'g')
  var out = str.replace(regex, function(m){
    return folds[m];
  });
  return out.toLowerCase();
}

var search = function(terms) {
  terms = fold(terms);
  var r = new RegExp(terms);
  var results = [];
  for (var i = 0; i < data.objects.length; i++) {
    var o = data.objects[i];
    if (fold(o.title).match(r)) {
      results.push(o);
    }
  }
  return results;
}

onmessage = function(event) {
  var started = new Date();

  if (event.data.type === 'search') {
    var results = search(event.data.terms);
    postMessage({
      type: 'results',
      duration: new Date() - started,
      results: results
    })
  }
}

var send = function() {
  postMessage({
    type: 'results',
    results: data
  });
}

init();
// setInterval(send, 3000);