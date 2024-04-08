-- Schema for storing computer science conferences


-- Could not: What constraints from the domain specification could not be enforced without assertions or triggers, if
-- any?
    -- To help ensure there are enough reviewers for submissions, at least one author on each paper must be a 
    -- reviewer. This is not a requirement for posters.
        -- This requires checks that span across Author, Submission, and Reviewer. Such a check thus requires an 
        -- assertion or trigger.

    -- Reviewers cannot review their own submissions, the submissions of anyone else with whom they are co-authors, 
    -- or the submissions of anyone else from their organization.
        -- Similar to the above, this requires checks across Author, Submission, and Reviewer. Therefore an 
        -- assertion or trigger is needed.

    -- A submission must receive at least three reviews before it can have a decision – either “accept” or “reject”.
        -- This requires dynamic counting of reviews, and thus cannot be enforced without assertions or triggers.
    
    -- Each review recommends a decision, and a submission cannot be accepted if no reviewer recommended “accept”.
        -- Much like the previous, this constraint requires dynamic counting of reviews, therefore it must use
        -- assertions or triggers.

    -- Submissions that have previously been accepted cannot be submitted again later.
        -- This requires cross table checking across Submission and Review, and also requires checking past data.
        -- As such, it requires assertions or triggers.

    -- Multiple presentations can be scheduled at the same time but no author can have two presentations at the 
    -- same time, with one exception – an author can have one paper and poster at the same time, as long as they 
    -- are not the sole author on either of them.
        -- This constraint involves checking across Presentation, Session, and also across multiple presentations
        -- and checking their scheduling. Thus, it requires assertions or triggers.

    -- At least one author on every accepted submission must be registered for the conference.
        -- As with many other constraints, this one requires cross table checks on Submission, Author, and
        -- Registration, and cannot be done without assertions or triggers.

    -- Conference chairs must have been on the organizing committee for that conference at least twice before 
    -- becoming conference chair, unless the conference is too new.
        -- This involves checking the history of committee memberships, which involves getting past data as well
        -- as checking conditions, and therefore needs assertions or triggers.


-- Did not: What constraints from the domain specification could have been enforced without assertions or triggers,
-- but were not enforced, if any? Why not?
    -- Most attendees pay a registration fee, and students pay a lower fee than other attendees.
        -- This constraint could have been enforced using a cosntraint in the Registration table to check if the
        -- attendee with the given att_id is a student, and then assigning the corresponding fee.
        -- However, this does not consider the fact that different conferences can theoretically have
        -- different fees. Thus, we would have to store fee values into the Conference and Workshop tables.
        -- Thus, we would need to have a subquery in Registration check if a registration is from a student
        -- or not, and store the corresponding registration fee in Registration. At this point, Conference, 
        -- Workshop, and Registration would be storing fee information, which would incur redundancy.
        -- In order to avoid unnecessary complexity and redundancy, we decided not to enforce this constraint. 


-- Extra constraints: What additional constraints that we didnt mention did you enforce, if any?
    -- Conferences with the same name can't start on the same date

    -- Workshops with the same names can't be in the same conference

    -- An attendee cannot attend the same conference twice

    -- A submission can't be submitted multiple times to the same conference

-- Note - extra constraints and assumptions are sort of interchangeable, as all assumptions we made
-- were enforced through UNIQUE statements, FKs, or otherwise.
-- Assumptions: What assumptions did you make?
    -- Assume 2 sessions can occur at the same time in one conference

    -- A facilitator must be an author

    -- A committee member must be an author

    -- A conference chair must be an author

    -- Conference chairs are a member of said conference

    -- A reviewer doesn't need to be an author

    -- To reduce redundancy, authors and reviewers who are not attending will not have their names 
    -- considered, as they are assumed to not be involved

    -- All attendees have an organization


-- Formatting according to these rules:
    -- An 80-character line limit is used.

    -- Keywords are capitalized consistently, either always in uppercase or always in lowercase.
    
    -- Table names begin with a capital letter and if multi-word names, use CamelCase.
    
    -- attribute names are not capitalized.
    
    -- Line breaks and indentation are used to assist the reader in parsing the code.


-- General principles:
    -- Avoid redundancy.
    
    -- Avoid designing your schema in such a way that there are attributes that can be null.
    
    -- If a constraint given above in the domain description can be expressed without assertions or triggers, 
    -- it should be enforced by your schema, unless you can articulate a good reason not to do so.
    
    -- There may be additional constraints that make sense but were not specified in the domain description. You
    -- get to decide on whether to enforce any of these in your DDL.

DROP SCHEMA IF EXISTS A3Conference CASCADE;
CREATE SCHEMA A3Conference;
SET SEARCH_PATH TO A3Conference;

-- Types.

CREATE TYPE A3Conference.submission_type AS ENUM (
    'paper', 'poster'
);

CREATE TYPE A3Conference.review_decision AS ENUM (
    'accept', 'reject'
);

-- This ENUM was included in case any new session types were to be introduced
CREATE TYPE A3Conference.session_type AS ENUM ( 
    'paper session', 'poster session'
);

CREATE TYPE A3Conference.conflict_type AS ENUM (
    'co-author', 'organization', 'other', 'none'
);


-- Tables.

-- An attendee of a conference.
CREATE TABLE IF NOT EXISTS Attendee (
    -- Unique attendee identifier
    att_id INT PRIMARY KEY,
    -- The attendee's name
    att_name TEXT NOT NULL,
    -- The attendee's contact information
    att_contact TEXT NOT NULL,
    -- The attendee's organization
    att_org TEXT NOT NULL,
    -- True if the attendee is a student
    is_student BOOLEAN NOT NULL
);

-- An author who writes papers/posters.
CREATE TABLE IF NOT EXISTS Author (
    -- Unique author identifier
    auth_id INT PRIMARY KEY,
    att_id INT NOT NULL,
    -- The name of the author
    auth_name TEXT NOT NULL,
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A computer science conference.
CREATE TABLE IF NOT EXISTS Conference (
    -- Unique conference identifier
    conf_id INT PRIMARY KEY,
    -- The name of the conference
    cname TEXT NOT NULL,
    -- The location of the conference
    clocation TEXT NOT NULL,
    -- The start and end dates of the conference
    cstart_date DATE NOT NULL,
    cend_date DATE NOT NULL,
    -- The conference fees
    regular_fee DECIMAL(10, 2) NOT NULL,
    student_fee DECIMAL(10, 2) NOT NULL,
    UNIQUE(cname, cstart_date),
    CHECK (cstart_date < cend_date)
);

-- A submission to a conference.
CREATE TABLE IF NOT EXISTS Submission (
    -- Unique submission identifier
    sub_id INT PRIMARY KEY,
    -- The title of the submission
    title TEXT NOT NULL,
    -- The type of submission 
    stype submission_type NOT NULL,
    conf_id INT NOT NULL,
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An author who contributed to a submission.
-- Relation connecting Author <==> Submission.
CREATE TABLE IF NOT EXISTS Contributor (
    auth_id INT NOT NULL,
    sub_id INT NOT NULL,
    -- The order of author names on a given submission
    auth_order INT NOT NULL,
    CHECK (auth_order > 0),
    UNIQUE (sub_id, auth_order),
    PRIMARY KEY (auth_id, sub_id),
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An author who reviewed a submission.
CREATE TABLE IF NOT EXISTS Reviewer (
    -- Unique reviewer identifier
    reviewer_id INT PRIMARY KEY,
    -- Any possible reviewer conflicts
    confl_type conflict_type NOT NULL,
    att_id INT NOT NULL,
    auth_id INT NOT NULL,
    FOREIGN KEY (auth_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE
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
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A session scheduled during a conference.
CREATE TABLE IF NOT EXISTS Session (
    -- Unique session identifier
    sess_id INT PRIMARY KEY,
    conf_id INT NOT NULL,
    -- Paper or poster session
    sess_type session_type NOT NULL,
    -- The start and end time of the session
    sess_start_time TIMESTAMP NOT NULL,
    sess_end_time TIMESTAMP NOT NULL,
    -- The chair of a paper session
     -- Will result in null values unfortunately, no NOT NULL
    sess_chair_id INT,
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sess_chair_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (sess_start_time < sess_end_time)
);

-- A presentation of a submission scheduled during a session.
CREATE TABLE IF NOT EXISTS Presentation (
    sess_id INT NOT NULL,
    sub_id INT NOT NULL,
    pres_id INT NOT NULL,
    -- The start time of the presentation
    pres_start_time TIMESTAMP NOT NULL,
    PRIMARY KEY (sess_id, sub_id),
    FOREIGN KEY (sess_id) REFERENCES Session(sess_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sub_id) REFERENCES Submission(sub_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pres_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A user registration for a conference.
-- Relation connecting Attendee <==> Conference.
CREATE TABLE IF NOT EXISTS Registration ( 
    att_id INT NOT NULL,
    conf_id INT NOT NULL,
    PRIMARY KEY (att_id, conf_id),
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A workshop at a conference.
CREATE TABLE IF NOT EXISTS Workshop (
    -- Unique workshop identifier
    work_id INT PRIMARY KEY,
    -- The name of the workshop
    wname TEXT NOT NULL,
    conf_id INT NOT NULL,
    -- The workshop fees
    regular_fee DECIMAL(10, 2) NOT NULL,
    student_fee DECIMAL(10, 2) NOT NULL,
    UNIQUE(wname, conf_id),
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A registration for a workshop.
CREATE TABLE IF NOT EXISTS WorkshopRegistration (
    att_id INT NOT NULL,
    work_id INT NOT NULL,
    PRIMARY KEY (att_id, work_id),
    FOREIGN KEY (att_id) REFERENCES Attendee(att_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (work_id) REFERENCES Workshop(work_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A facilitator for a workshop.
-- Relation connecting Author/Facilitator <==> Workshop.
CREATE TABLE IF NOT EXISTS Facilitator ( 
    fac_id INT NOT NULL,
    work_id INT NOT NULL,
    PRIMARY KEY (fac_id, work_id),
    FOREIGN KEY (fac_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (work_id) REFERENCES Workshop(work_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- An organizing committee at a conference.
CREATE TABLE IF NOT EXISTS Committee (
    -- Unique committee identifier
    comm_id INT PRIMARY KEY,
    -- The name of the committee
    comm_name TEXT NOT NULL,
    conf_id INT NOT NULL,
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A member of an organizing committee.
-- Relation connecting Author/Committee member <==> Workshop.
CREATE TABLE IF NOT EXISTS CommitteeMember ( 
    comm_id INT NOT NULL,
    member_id INT NOT NULL,
    PRIMARY KEY (comm_id, member_id),
    FOREIGN KEY (comm_id) REFERENCES Committee(comm_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- A conference chair for a committee.
CREATE TABLE IF NOT EXISTS ConferenceChairs (
    -- Unique conference chair identifier
    chair_id INT PRIMARY KEY,
    conf_id INT NOT NULL,
    member_id INT NOT NULL,
    UNIQUE(conf_id, member_id),
    FOREIGN KEY (conf_id) REFERENCES Conference(conf_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Author(auth_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
