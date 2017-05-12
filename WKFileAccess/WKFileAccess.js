// http://stackoverflow.com/questions/16245767/creating-a-blob-from-a-base64-string-in-javascript#answer-16245768
function base64ToFile(b64String, name, { type }) {
    const characters = atob(b64String)
    const numbers = new Array(characters.length)
    for (let i = 0; i < characters.length; i++) {
        numbers[i] = characters.charCodeAt(i)
    }
    const bytes = new Uint8Array(numbers)
    return new File([bytes], name, { type })
}


WKFileAccess.requestFile = async function(url) {
    try {
        const { content, name, type } = await WKFileAccess.requestFile_(url)
        return base64ToFile(content, name, { type })
    } catch (reason) {
        throw new Error(reason)
    }
}
