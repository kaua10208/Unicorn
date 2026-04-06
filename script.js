// filepath: /home/kaua/Área de trabalho/Project Unicorn/script.js

document.getElementById('accept-btn').addEventListener('click', function() {
    window.location.href = 'accept.html';
});

document.getElementById('decline-btn').addEventListener('click', function() {
    alert('Você recusou a instalação. Agradecemos por considerar nosso projeto.');
});