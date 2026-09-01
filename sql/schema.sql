CREATE TABLE IF NOT EXISTS Issues (
    id SERIAL,
    fandomURL VARCHAR(100),
    storyName VARCHAR(100),
    series VARCHAR(50) NOT NULL,
    volume SMALLINT NOT NULL,
    issueNum SMALLINT NOT NULL,
    coverDate DATE,
    releaseDate DATE,

    CONSTRAINT Issues_PK PRIMARY KEY (id),
    CONSTRAINT Issues_Unique UNIQUE (fandomURL, storyNum)
);

CREATE DOMAIN roleDomain AS VARCHAR(8)
CHECK (VALUE IN (
    'Writer',
    'Penciler',
    'Inker',
    'Colorist',
    'Letterer',
    'Editor'
));

CREATE TABLE IF NOT EXISTS Contributors (
    name VARCHAR(50),
    role roleDomain,
    comicID INTEGER,

    CONSTRAINT contributor_PK PRIMARY KEY (name, role, comicID),
    CONSTRAINT contributor_comic_FK
        FOREIGN KEY (comicID) REFERENCES Issues (id)
);

CREATE TABLE IF NOT EXISTS Chronology (
    id SERIAL NOT NULL,
    prevID INTEGER,
    currID INTEGER,
    degree SMALLINT,

    CONSTRAINT Chronology_PK PRIMARY KEY (id),
    CONSTRAINT Chronology_previous_FK
        FOREIGN KEY (prevID) REFERENCES Issues (id),
    CONSTRAINT Chronology_current_FK
        FOREIGN KEY (currID) REFERENCES Issues (id)
);

CREATE TABLE IF NOT EXISTS Character (
    id SERIAL,
    fandomURL VARCHAR(100),
    characterName VARCHAR(100),
    universe VARCHAR(50),

    CONSTRAINT Character_PK PRIMARY KEY (id),
    CONSTRAINT Character_Unique UNIQUE (fandomURL)
);

CREATE TABLE IF NOT EXISTS Alias (
    characterID INTEGER,
    alias VARCHAR(100),

    CONSTRAINT Alias_PK PRIMARY KEY (characterID, alias),
    CONSTRAINT Alias_Character_FK
        FOREIGN KEY (characterID) REFERENCES Character (id)
);

CREATE TABLE IF NOT EXISTS characterOverwrite (
    overwrittencharacterID INTEGER,
    changeToCharacterID INTEGER,

    CONSTRAINT characterOverwrite_PK
        PRIMARY KEY (overwrittencharacterID, changeToCharacterID),

    CONSTRAINT characterOverwrite_Overwritten_FK
        FOREIGN KEY (overwrittencharacterID) REFERENCES Character (id),

    CONSTRAINT characterOverwrite_ChangedTo_FK
        FOREIGN KEY (changeToCharacterID) REFERENCES Character (id)
);

CREATE TABLE IF NOT EXISTS Appearance (
    issueID INTEGER,
    characterID INTEGER,
    importance SMALLINT,

    CONSTRAINT Appearance_PK PRIMARY KEY (issueID, characterID),

    CONSTRAINT Appearance_Issue_FK
        FOREIGN KEY (issueID) REFERENCES Issues (id),

    CONSTRAINT Appearance_Character_FK
        FOREIGN KEY (characterID) REFERENCES Character (id)
);