const URLInput = document.getElementById("fandomURLInput");
const URLSubmitButton = document.getElementById("URLSubmitButton");

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
    createHTML(result);
}

URLSubmitButton.addEventListener("click", sendURL);
URLInput.addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      sendURL();
    }
});



async function createHTML(data){
    const titleInput = document.getElementById("titleInput");
    titleInput.value = data.issueTitle;

    const volumeInput = document.getElementById("volumeInput");
    volumeInput.value = data.volume;

    const issueNumInput = document.getElementById("issueNumInput");
    issueNumInput.value = data.issueNum;

    const releaseDateInput = document.getElementById("releaseDateInput");
    releaseDateInput.value = data.releaseDate;

    const coverDateInput = document.getElementById("coverDateInput");
    coverDateInput.value = data.coverDate;

    //Stories
    for (let i = 0; i < data.stories.length; i++){
        addStoryDiv(data.stories[i], i);
    }
}

async function addStoryDiv(storyData, storyNum){
    console.log(storyData.title);
    const parentDiv = document.getElementById("storyBox");
    const storyDiv = document.createElement("div");
    storyDiv.className = "story";
    storyDiv.id = "story"+storyNum;
    parentDiv.appendChild(storyDiv);

    //Title
    const titleDiv = document.createElement("div");
    titleDiv.className = "titleByInput";
    storyDiv.appendChild(titleDiv);

    const titleTitle = document.createElement("h1");
    titleTitle.textContent = "Title:";
    titleDiv.appendChild(titleTitle);

    const storyTitle = document.createElement("input");
    storyTitle.value = storyData.title;
    storyTitle.className = "inputBox";
    titleDiv.appendChild(storyTitle);
    



    //Contributors
    const contributorsDiv = document.createElement("div");
    storyDiv.appendChild(contributorsDiv);
    const contributorsTitle = document.createElement("h1");
    contributorsTitle.textContent = "Contributors";
    contributorsDiv.appendChild(contributorsTitle);

    //Loop through contributors
    for (const [role, people] of Object.entries(storyData.contributors)){
        const contributorRole = document.createElement("h3");
        contributorRole.textContent = role;
        contributorsDiv.appendChild(contributorRole);

        for (var i = 0; i < people.length; i++){
            const contributor = document.createElement("input");
            contributor.value = people[i].url;
            contributor.className = "inputBox";
            contributorsDiv.appendChild(contributor);
        }
    }



    //Characters
    const charactersDiv = document.createElement("div");
    storyDiv.appendChild(charactersDiv);
    const charactersTitle = document.createElement("h1");
    charactersTitle.textContent = "Characters";
    charactersDiv.appendChild(charactersTitle);

    for (var i = 0; i < storyData.characters.length; i++){
        const characterDiv = document.createElement("div");
        charactersDiv.appendChild(characterDiv);

        const characterNameDiv = document.createElement("div");
        characterNameDiv.className = "titleByInput";
        characterDiv.appendChild(characterNameDiv);
        const nameTitle = document.createElement("h2");
        nameTitle.textContent = "Name: ";
        characterNameDiv.appendChild(nameTitle);
        const name = document.createElement("input");
        name.value = storyData.characters[i].characterName;
        name.className = "inputBox";
        characterNameDiv.appendChild(name);
    }
}