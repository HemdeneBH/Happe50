function loadUserTheme() {
    let userPrefTheme = localStorage.getItem('theme');
    if (!userPrefTheme) {
        userPrefTheme = 'darkTheme';
    }
    this.template.host.className = userPrefTheme;
}

function switchTheme(styleName) {
    const oldStyle = styleName == 'darkTheme' ? 'lightTheme' : 'darkTheme';
    this.template.host.className = styleName;
    this.template.querySelectorAll('.' + oldStyle).forEach(element => {
        element.switchStyle(styleName);
    });
    document.querySelectorAll('.lightTheme, .darkTheme').forEach(element => {
        element.classList.remove('lightTheme', 'darkTheme');
        element.classList.add(styleName);
    });
}


export {
    loadUserTheme,
    switchTheme,
};