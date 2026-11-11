(function(){
  var btn=document.querySelector('.menu-btn'),nav=document.getElementById('nav');
  btn.addEventListener('click',function(){var o=nav.classList.toggle('open');btn.setAttribute('aria-expanded',o);btn.setAttribute('aria-label',o?'Chiudi il menu':'Apri il menu')});
  nav.addEventListener('click',function(e){if(e.target.tagName==='A'){nav.classList.remove('open');btn.setAttribute('aria-expanded','false')}});
  var lb=document.getElementById('lightbox'),img=lb.querySelector('img'),items=[],i=0;
  function show(n){i=(n+items.length)%items.length;img.src=items[i].src;img.alt=items[i].alt}
  var btns=[].slice.call(document.querySelectorAll('#gallery button'));
  btns.forEach(function(b){b.addEventListener('click',function(){items=btns.filter(function(x){return !x.hidden}).map(function(x){return x.querySelector('img')});show(items.indexOf(b.querySelector('img')));lb.showModal()})});
  var chips=[].slice.call(document.querySelectorAll('.chip'));
  chips.forEach(function(ch){ch.addEventListener('click',function(){chips.forEach(function(x){x.setAttribute('aria-pressed',x===ch)});var f=ch.dataset.f;btns.forEach(function(b){b.hidden=f!=='Tutte'&&b.dataset.cat!==f})})});
  lb.querySelector('.lb-close').onclick=function(){lb.close()};
  lb.querySelector('.lb-prev').onclick=function(){show(i-1)};
  lb.querySelector('.lb-next').onclick=function(){show(i+1)};
  lb.addEventListener('click',function(e){if(e.target===lb)lb.close()});
  document.addEventListener('keydown',function(e){if(!lb.open)return;if(e.key==='ArrowLeft')show(i-1);if(e.key==='ArrowRight')show(i+1)});
  var sc=document.querySelector('.sticky-cta'),c=document.getElementById('contatti');
  if('IntersectionObserver' in window){new IntersectionObserver(function(en){sc.style.display=en[0].isIntersecting?'none':''},{threshold:.2}).observe(c)}
})();
