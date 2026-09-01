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
    print(page)
    title, volIssue = page.split("_Vol_")
    print(title, volIssue)
    volume, issue = volIssue.split("_")
    print(title, volume, issue)
    returnJSON["issueURL"] = url
    returnJSON["issueTitle"] = title.replace("_", " ")
    returnJSON["volume"] = volume
    returnJSON["issueNum"] = issue

    #Dates
    coverSidebar = soup.find("aside", class_="portable-infobox pi-background pi-border-color pi-theme-comic pi-layout-default")
            

    


    return returnJSON





app.run(port=5000)