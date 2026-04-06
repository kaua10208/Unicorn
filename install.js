document.getElementById('open_source').addEventListener('click', function() {
    const link = 'https://github.com/kaua10208/Unicorn/releases/download/main-test/linux.zip';
    window.location.href = link;
});

document.getElementById('windows').addEventListener('click', function() {
    alert('Ainda não temos um pacote para Windows, mas estamos trabalhando nisso! Fique atento para futuras atualizações do projeto!');
});