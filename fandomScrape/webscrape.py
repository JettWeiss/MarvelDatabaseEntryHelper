from flask import Flask, jsonify, request
from flask_cors import CORS
from bs4 import BeautifulSoup
import requests

app = Flask(__name__)
CORS(app)

@app.route("/scrape", methods=["POST"])
def process():
    data = request.json

    url = data["url"]
    print(url)
    try:
        result = scrapeSite(url)
        return jsonify(result)
    except Exception as e:
        print("ERROR:", e)
        raise


def scrapeSite(url):
    returnJSON = {}

    requestURL = "https://marvel.fandom.com/api.php"
    page = url.split("https://marvel.fandom.com/wiki/")[1]
    
    params = {
        "action": "parse",
        "page": page,
        "format": "json"
    }
    
    response = requests.get(requestURL, params=params)
    html = response.json()["parse"]["text"]["*"]
    soup = BeautifulSoup(html, "html.parser")

    #Write to temp file
    with open("page.html", "w", encoding="utf-8") as f:
        f.write(html)

    #Issue Details
    title, volume, issue = "Title not found", "Volume not found", "Issue not found"
    title, volIssue = page.split("_Vol_")
    volume, issue = volIssue.split("_")
    returnJSON["issueURL"] = url
    returnJSON["issueTitle"] = title.replace("_", " ")
    returnJSON["volume"] = volume
    returnJSON["issueNum"] = issue

    #Dates
    releaseDate, coverDate = "0000-00-00", "0000-00-00"
    coverSidebar = soup.find("aside", class_="portable-infobox pi-background pi-border-color pi-theme-comic pi-layout-default")
    
    #Find h3 with 'Release Date' and 'Cover Date', get next div, steal text.
    
    headers = coverSidebar.find_all('h3')
    for i in range(len(headers)): #TODO: Transform dates into SQL Format here?
        if(headers[i].text == "Release Date"):
            print("Release Date")
            releaseDateDiv = headers[i].find_next("div")
            print(releaseDateDiv.text)
            releaseDate = releaseDateDiv.text

        if(headers[i].text == "Cover Date"):
            print("Cover Date")
            coverDateDiv = headers[i].find_next("div")
            print(coverDateDiv.text)
            coverDate = coverDateDiv.text

    returnJSON["releaseDate"] = releaseDate
    returnJSON["coverDate"] = coverDate


    #Stories Names and Contributors
    storiesList = []
    storiesSidebar = coverSidebar.find_next("aside", class_="portable-infobox pi-background pi-border-color pi-theme-comic pi-layout-default")
    storiesHTMLList = storiesSidebar.find_all("h2")
    for i in range(len(storiesHTMLList)): #TODO: Maybe fix the triple nested loop
        storyJSON = {}
        storyTitle = storiesHTMLList[i].text.split(". \"")[1][:-1] #Extracts the title from x. "___"
        storyJSON["title"] = storyTitle

        storyJSON["contributors"] = {}
        contributors = storiesHTMLList[i].find_next("section").find_all("h3")
        print(len(contributors))
        for j in range(len(contributors)):
            storyJSON["contributors"][contributors[j].text] = []
            contributorNames = contributors[j].find_next("div").find_all("a")
            for k in range(len(contributorNames)): #TODO: Change URL to another scrape of name to populate contributor table values
                contributorJSON = scrapeContributor(contributorNames[k]["href"])
                storyJSON["contributors"][contributors[j].text].append(contributorJSON)

        storyJSON["characters"] = []
        storiesList.append(storyJSON)
        
    for i in range(len(storiesList)):
        print(storiesList[i])
        print()
    returnJSON["stories"] = storiesList


    return returnJSON


def scrapeContributor(url):
    return {"url": url}

def scrapeCharacter(url):
    return




app.run(port=5000)