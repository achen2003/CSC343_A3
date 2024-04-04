-- Schema for storing computer science conferences

-- Could not: What constraints from the domain specification could not be enforced without assertions or triggers, if
-- any?

-- Did not: What constraints from the domain specification could have been enforced without assertions or triggers,
-- but were not enforced, if any? Why not?

-- Extra constraints: What additional constraints that we didnt mention did you enforce, if any?

-- Assumptions: What assumptions did you make?
    -- Conferences with the same name can't start on the same date
    -- Assume 2 sessions can occur at the same time in one conference
    -- Workshops with the same names can't be in the same conference
    -- A facilitator must be an author
    -- A committee member must be an author
    -- A conference chair must be an author
    -- Conference chairs are a member of said conference
    -- A reviewer doesn't need to be an author
    -- To reduce redundancy, authors and reviewers who are not attending will not have their names 
        -- considered, and are assumed to be not involved
    -- An attendee cannot attend the same conference twice

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

CREATE TYPE A3Conference.review_decision AS ENUM (
    'accepted', 'rejected'
);

CREATE TYPE A3Conference.session_type AS ENUM (
    'paper session', 'poster session'
);

CREATE TYPE A3Conference.conflict_type AS ENUM (
    'co-author', 'organization', 'other', 'none'
);

// CREATE TYPE A3Conference.attendee_type AS ENUM (
//     'author', 'student'
// );

// Tables ===============================

-- An author who writes papers/posters
CREATE TABLE IF NOT EXISTS Author (
    -- Unique author identifier
    auth_id INT PRIMARY KEY,
    -- The organization of which the author is a member of
    organization TEXT NOT NULL,
    att_id INT NOT NULL,
    UNIQUE(organization, contact_info)
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
);

-- An author who contributed to a submission // Relation connecting Author <==> Submissino
CREATE TABLE IF NOT EXISTS Contributor (
    auth_id INT NOT NULL,
    sub_id INT NOT NULL,
    PRIMARY KEY (auth_id, sub_id),
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A submission to a conference
CREATE TABLE IF NOT EXISTS Submission (
    -- Unique submission identifier
    sub_id INT PRIMARY KEY,
    -- The title of the submission
    title TEXT NOT NULL,
    -- The type of submission 
    stype submission_type NOT NULL
    conf_id INT NOT NULL,
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A computer science conference
CREATE TABLE IF NOT EXISTS Conference (
    -- Unique conference identifier
    conf_id INT PRIMARY KEY,
    -- Name of the conference
    cname TEXT NOT NULL,
    -- Location of the conference
    clocation TEXT NOT NULL,
    -- Start and end dates of the conference
    cstart_date DATE NOT NULL,
    cend_date DATE NOT NULL,
    UNIQUE(cname, cstart_date),
    CHECK (cstart_date < cend_date) // Need?
);

-- An author who reviewed a submission
CREATE TABLE IF NOT EXISTS Reviewer (
    -- Unique reviewer identifier
    reviewer_id INT PRIMARY KEY,
    -- Any possible reviewer conflicts
    confl_type conflict_type NOT NULL,
    att_id INT NOT NULL,
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (auth_id, sub_id)
);

-- A review made by a reviewer
CREATE TABLE IF NOT EXISTS Review (
    -- Unique review identifier
    rev_id INT PRIMARY KEY,
    reviewer_id INT NOT NULL,
    sub_id INT NOT NULL,
    decision review_decision NOT NULL,
    FOREIGN KEY (reviewer_id) REFERENCES Reviewer(reviewer_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
);

-- A session scheduled during a conference
CREATE TABLE IF NOT EXISTS Session (
    -- Unique session identifier
    sess_id INT PRIMARY KEY,
    conf_id INT NOT NULL,
    -- Paper or poster session
    sess_type session_type NOT NULL,
    -- The start and end time of the session
    sess_start_time DATETIME NOT NULL,
    sess_end_time DATETIME NOT NULL,
    -- The chair of a paper session
    sess_chair_id INT, // Will result in null values unfortunately, no NOT NULL
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sess_chair_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (sess_start_time < sess_end_time)
);

-- A presentation of a submission scheduled during a session
CREATE TABLE IF NOT EXISTS Presentation (
    sess_id INT NOT NULL,
    sub_id INT NOT NULL,
    -- The start time of the presentation
    pres_start_time DATETIME NOT NULL,
    PRIMARY KEY (sess_id, sub_id), // Can't have the 2 of the same submissions in the same session
    FOREIGN KEY (sess_id) REFERENCES Session(sess_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A user registration for a conference 
CREATE TABLE IF NOT EXISTS Registration ( // Relation connecting Attendee <==> Conference
    att_id INT NOT NULL,
    conf_id INT NOT NULL,
    -- The registration fee
    reg_fee DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (att_id, conf_id),
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An attendee of a conference
CREATE TABLE IF NOT EXISTS Attendee (
    -- Unique attendee identifier
    att_id INT PRIMARY KEY,
    -- The attendee's name
    att_name TEXT NOT NULL,
    -- The attendee's contact information
    att_contact TEXT NOT NULL,
    -- The attendee's organization // Assume all attendees have an org?
    att_org TEXT NOT NULL,
    -- True if the attendee is a student
    is_student BOOLEAN NOT NULL
);

-- A workshop at a conference
CREATE TABLE IF NOT EXISTS Workshop (
    -- Unique workshop identifier
    work_id INT PRIMARY KEY,
    -- The name of the workshop
    wname TEXT NOT NULL,
    conf_id INT NOT NULL,
    UNIQUE(name, conference_id),
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A facilitator for a workshop
CREATE TABLE IF NOT EXISTS Facilitator ( // Relation connecting Author/Facilitator <==> Workshop
    fac_id INT NOT NULL,
    work_id INT NOT NULL,
    PRIMARY KEY (fac_id, work_id),
    FOREIGN KEY (fac_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (work_id) REFERENCES Workshop(work_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An organizing committee at a conference
CREATE TABLE IF NOT EXISTS Committee (
    -- Unique committee identifier
    comm_id INT PRIMARY KEY,
    conf_id INT NOT NULL,
    member_id INT NOT NULL,
    UNIQUE(conf_id, member_id),
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE
)

-- A conference chair for a committee
CREATE TABLE IF NOT EXISTS ConferenceChairs (
    -- Unique conference chair identifier
    chair_id INT PRIMARY KEY,
    conf_id INT NOT NULL,
    member_id INT NOT NULL,
    UNIQUE(conf_id, member_id)
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE
)





