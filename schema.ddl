-- Schema for storing computer science conferences

-- Could not: What constraints from the domain specification could not be enforced without assertions or triggers, if
-- any?

-- Did not: What constraints from the domain specification could have been enforced without assertions or triggers,
-- but were not enforced, if any? Why not?

-- Extra constraints: What additional constraints that we didnt mention did you enforce, if any?

-- Assumptions: What assumptions did you make?

-- Formatting according to these rules:
    -- An 80-character line limit is used.
    -- Keywords are capitalized consistently, either always in uppercase or always in lowercase.
    -- Table names begin with a capital letter and if multi-word names, use CamelCase.
    -- attribute names are not capitalized.
    -- Line breaks and indentation are used to assist the reader in parsing the code.


DROP SCHEMA IF EXISTS A3Conference CASCADE;
CREATE SCHEMA A3Conference;
SET SEARCH_PATH TO A3Conference;

// Types ===============================

CREATE TYPE A3Conference.submission_type AS ENUM (
    'paper', 'poster'
);

CREATE TYPE A3Conference.submission_decision AS ENUM (
    'accepted', 'rejected'
);

CREATE TYPE A3Conference.session_type AS ENUM (
    'paper session', 'poster session'
);

// Tables ===============================

-- An author of a sbumission
CREATE TABLE IF NOT EXISTS Author (
    -- Unique author identifier
    auth_id INT PRIMARY KEY,
    -- The name of the author
    name TEXT NOT NULL,
    -- The organization of which the author is a member of
    organization TEXT NOT NULL,
    -- The position of the author's name on a paper
    order INT NOT NULL
);

-- An author who reviewed a submission
CREATE TABLE IF NOT EXISTS Reviewer (
    auth_id INT NOT NULL,
    sub_id INT NOT NULL,
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (auth_id, sub_id)
);

-- An author who contributed to a submission
CREATE TABLE IF NOT EXISTS Contributor (
    auth_id INT NOT NULL,
    sub_id INT NOT NULL,
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (auth_id, sub_id)    
);

-- A submission to a conference
CREATE TABLE IF NOT EXISTS Submission (
    -- Unique submission identifier
    sub_id INT PRIMARY KEY,
    -- The title of the submission
    title TEXT NOT NULL,
    -- The type of submission 
    stype submission_type NOT NULL
    -- Whether the submission is accepted or not
    accepted BOOLEAN NOT NULL,
    auth_id INT NOT NULL,
    // PRIMARY KEY (title, stype, auth_id)
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TALE IF NOT EXISTS Conference (

);



