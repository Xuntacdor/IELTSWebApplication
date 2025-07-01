function showSection(index) {
    const sections = document.querySelectorAll('.section-content');
    sections.forEach(div => div.style.display = 'none');
    document.getElementById('section-' + index).style.display = 'flex';
}
