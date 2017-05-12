function emptyNode(node) {
    while (node.firstChild) {
        node.removeChild(node.firstChild)
    }
}

function displayNode(node) {
    const displayNode = document.querySelector('#example .display')
    emptyNode(displayNode)
    displayNode.appendChild(node)
}

function displayText(text) {
    const preNode = document.createElement('pre')
    preNode.textContent = text
    displayNode(preNode)
}

function displayImage(url) {
    const imageNode = document.createElement('img')
    imageNode.src = url
    displayNode(imageNode)
}

function displayFile(file) {
    const reader = new FileReader()

    let read, display

    if (file.type.startsWith('image')) {
        read = file => reader.readAsDataURL(file)
        display = url => displayImage(url)
    } else {
        read = file => reader.readAsText(file)
        display = text => displayText(text)
    }

    reader.addEventListener('load', function() {
        display(this.result)
    })

    read(file)
}

async function displayFileURLContents(url) {
    try {
        const file = await WKFileAccess.requestFile(url)
        displayFile(file)
    } catch (error) {
        alert(error.message)
    }
}
