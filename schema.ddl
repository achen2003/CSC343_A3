-- Schema for storing computer science conferences

-- Could not: What constraints from the domain specification could not be enforced without assertions or triggers, if
-- any?

-- Did not: What constraints from the domain specification could have been enforced without assertions or triggers,
-- but were not enforced, if any? Why not?

-- Extra constraints: What additional constraints that we didn’t mention did you enforce, if any?
-- Assumptions: What assumptions did you make?


DROP SCHEMA IF EXISTS A3Conference CASCADE;
CREATE SCHEMA A3Conference;
SET SEARCH_PATH TO A3Conference;

CREATE TYPE A3Conference