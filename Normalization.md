Normalization

Resource(ResourceID: INT, ResourceName: VARCHAR(50), GroupID: INT, UploaderID: INT, ResourceURL: TEXT, FileType: VARCHAR(20))
Primary Key: ResourceID
FKs: - UploaderID references Student(SID) - GroupID references Group(GroupID)
FDs: - ResourceID -> ResourceName, GroupID, UploaderID, ResourceURL, FileType - ResourceURL -> FileType

The above FDs violate BCNF since ResourceURL isn’t a superkey in the Resource relation.
So, we decompose into 2 separate relations to satisfy BCNF: - Resource(ResourceID: INT, ResourceName: VARCHAR(50), GroupID: INT, UploaderID: INT, ResourceURL: TEXT) - ResourceType(ResourceURL: TEXT, FileType: VARCHAR(20))

Institution(Name: varchar(30), PostalCode: varchar(10), City: varchar(20), Province: varchar(20))
Primary Key: (Name, PostalCode)
FDs: - Name, PostalCode → City, Province - PostalCode -> City

Institution(Name, PostalCode, City, Province) violates BCNF principles since Postal Code is not a superkey.
Applying decomposition to Institution(Name, PostalCode, City, Province) gives result relations:

    Institution(Name: varchar(30), PostalCode: varchar(10))
        Primary Key: (Name, PostalCode)

    Location(PostalCode: varchar(10), City: varchar(20), Province: varchar(20))
        Primary Key: (PostalCode)
        FDs:
            - PostalCode -> City
            - PostalCode -> Province
