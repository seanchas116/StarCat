
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

function wrapTable() {
    const tables = [...document.querySelectorAll("table")];
    for (const table of tables) {
        const tableWrapper = document.createElement("div");
        tableWrapper.className = "table-wrapper";
        table.parentElement.insertBefore(tableWrapper, table);
        tableWrapper.insertBefore(table, null);
    }
}

function adjustContent(projectName) {
    resolveURLs(projectName);
    wrapTable();
}