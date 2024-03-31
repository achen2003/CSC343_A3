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

// Types:

CREATE TYPE A3Conference.submission_type AS ENUM (
    'paper', 'poster'
);

CREATE TYPE A3Conference.submission_decision AS ENUM (
    'accepted', 'rejected'
);

CREATE TYPE A3Conference.session_type AS ENUM (
    'paper session', 'poster session'
);


