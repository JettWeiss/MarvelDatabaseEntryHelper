const URLInput = document.getElementById("fandomURLInput");
const URLSubmitButton = document.getElementById("URLSubmitButton")
async function sendURL() {
    const URL = URLInput.value;

    const response = await fetch("http://localhost:5000/scrape", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            url: URL
        })
    });

    const result = await response.json();

    console.log(result);
}

URLSubmitButton.addEventListener("click", sendURL);
URLInput.addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      sendURL();
    }
});