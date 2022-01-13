use LessonDB

ALTER TABLE Persons
ADD Gender varchar(4) CHECK(Gender='Male')