const button=document.querySelector('.menu-button');
const nav=document.querySelector('.main-nav');
if(button&&nav){button.addEventListener('click',()=>nav.classList.toggle('open'));}
document.querySelectorAll('.main-nav a').forEach(a=>a.addEventListener('click',()=>nav&&nav.classList.remove('open')));