(function(t,e){function i(){var t=g.elements;return"string"==typeof t?t.split(" "):t}function n(t){var e=f[t[d]];return e||(e={},p++,t[d]=p,f[p]=e),e}function s(t,i,s){return i||(i=e),l?i.createElement(t):(s||(s=n(i)),i=s.cache[t]?s.cache[t].cloneNode():u.test(t)?(s.cache[t]=s.createElem(t)).cloneNode():s.createElem(t),i.canHaveChildren&&!h.test(t)?s.frag.appendChild(i):i)}function o(t,e){e.cache||(e.cache={},e.createElem=t.createElement,e.createFrag=t.createDocumentFragment,e.frag=e.createFrag()),t.createElement=function(i){return g.shivMethods?s(i,t,e):e.createElem(i)},t.createDocumentFragment=Function("h,f","return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&("+i().join().replace(/\w+/g,function(t){return e.createElem(t),e.frag.createElement(t),'c("'+t+'")'})+");return n}")(g,e.frag)}function a(t){t||(t=e);var i=n(t);if(g.shivCSS&&!r&&!i.hasCSS){var s,a=t;s=a.createElement("p"),a=a.getElementsByTagName("head")[0]||a.documentElement,s.innerHTML="x<style>article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}</style>",s=a.insertBefore(s.lastChild,a.firstChild),i.hasCSS=!!s}return l||o(t,i),t}var r,l,c=t.html5||{},h=/^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i,u=/^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i,d="_html5shiv",p=0,f={};(function(){try{var t=e.createElement("a");t.innerHTML="<xyz></xyz>",r="hidden"in t;var i;if(!(i=1==t.childNodes.length)){e.createElement("a");var n=e.createDocumentFragment();i="undefined"==typeof n.cloneNode||"undefined"==typeof n.createDocumentFragment||"undefined"==typeof n.createElement}l=i}catch(s){l=r=!0}})();var g={elements:c.elements||"abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup mark meter nav output progress section summary time video",version:"3.6.2pre",shivCSS:!1!==c.shivCSS,supportsUnknownElements:l,shivMethods:!1!==c.shivMethods,type:"default",shivDocument:a,createElement:s,createDocumentFragment:function(t,s){if(t||(t=e),l)return t.createDocumentFragment();for(var s=s||n(t),o=s.frag.cloneNode(),a=0,r=i(),c=r.length;c>a;a++)o.createElement(r[a]);return o}};t.html5=g,a(e)})(this,document);