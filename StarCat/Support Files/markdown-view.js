
function setHeaderPadding(height) {
    const padding = document.getElementById('header-padding');
    if (padding) {
        padding.style.height = height + "px";
    }
}

function resolveURLs(projectName) {
    function resolveURL(url) {
        if (!url || url.match(/https?:\/\//)) {
            return;
        } else if (url[0] == "/") {
            return "https://github.com" + url;
        } else {
            return "https://github.com/" + projectName + "/raw/master/" + url;
        }
    }

    for (const img of [...document.querySelectorAll("img")]) {
        const newURL = resolveURL(img.src);
        if (newURL) {
            img.src = newURL;
        }
    }
}
