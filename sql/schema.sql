--Issue table runs into issue with multiple stories in one issue
--Could make PK URL + story#?
CREATE TABLE IF NOT EXISTS Issues { 
    fandomURL VARCHAR(100),
    storyNum TINYINT DEFAULT 1,
    series VARCHAR(50) NOT NULL,
    volume TINYINT NOT NULL,  
    issueNum SMALLINT NOT NULL,
    coverDate DATE,
    releaseDate DATE,
    writer VARCHAR(50),
    artist VARCHAR(50),
    colorist VARCHAR(50),
    letterer VARCHAR(50),
    CONSTRAINT Issues_PK PRIMARY KEY (fandomURL, storyNum) 
};

CREATE TABLE IF NOT EXISTS Chronology {
    id SERIAL NOT NULL,
    prevIssueURL VARCHAR(100),
    prevIssueStoryNum TINYINT DEFAULT 1,
    currIssueURL VARCHAR(100),
    currIssueStoryNum TINYINT DEFAULT 1,
    degree TINYINT,
    CONSTRAINT Chronology_PK PRIMARY KEY (id),
    CONSTRAINT Chronology_previous_FK FOREIGN KEY (prevIssueURL, prevIssueStoryNum) REFERENCES Issues (fandomURL, storyNum),
    CONSTRAINT Chronology_current_FK FOREIGN KEY (currIssueURL, currIssueStoryNum) REFERENCES Issues (fandomURL, storyNum)
};

CREATE TABLE IF NOT EXISTS Character {
    fandomURL VARCHAR(100),
    characterName VARCHAR(100),
    universe VARCHAR(50),
    CONSTRAINT Character_PK PRIMARY KEY (fandomURL)
};
CREATE TABLE IF NOT EXISTS Alias {
    characterURL VARCHAR(100),
    alias VARCHAR(100),
    CONSTRAINT Alias_PK PRIMARY KEY (characterURL, alias),
    CONSTRAINT Alias_Character_FK FOREIGN KEY (characterURL) REFERENCES Character (fandomURL)
};
CREATE TABLE IF NOT EXISTS characterOverwrite {
    overwrittencharacterURL VARCHAR(100),
    changeToCharacterURL VARCHAR(100),
    CONSTRAINT characterOverwrite_PK PRIMARY KEY (overwrittencharacterURL, changeToCharacterURL),
    CONSTRAINT characterOverwrite_Character_FK FOREIGN KEY (overwrittencharacterURL) REFERENCES Character (fandomURL)
    CONSTRAINT characterOverwrite_Character_FK FOREIGN KEY (changeToCharacterURL) REFERENCES Character (fandomURL)
}


CREATE TABLE IF NOT EXISTS Appearance {
    issueURL VARCHAR(100),
    storyNum TINYINT DEFAULT 1,
    characterURL VARCHAR(100),
    importance TINYINT, 
    CONSTRAINT Appearance_PK PRIMARY KEY (id),
    CONSTRAINT Appearance_Issue_FK FOREIGN KEY (issueURL, storyNum) REFERENCES Issues (fandomURL, storyNum),
    CONSTRAINT Appearance_Character_FK FOREIGN KEY (characterURL) REFERENCES Character (fandomURL)
};