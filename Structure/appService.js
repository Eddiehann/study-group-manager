

const oracledb = require('oracledb');
const loadEnvFile = require('./utils/envUtil');

const envVariables = loadEnvFile('./.env');

console.log('Loaded env variables**************************:', envVariables);

const dbConfig = {
    user: envVariables.ORACLE_USER,
    password: envVariables.ORACLE_PASS,
    connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
    poolMin: 1,
    poolMax: 3,
    poolIncrement: 1,
    poolTimeout: 60
};

async function initializeConnectionPool() {
    try {
        console.log('Connecting with config:', dbConfig);
        await oracledb.createPool(dbConfig);
        console.log('Connection pool started');
    } catch (err) {
        console.error('Initialization error: ' + err.message);
    }
}

initializeConnectionPool();

process.once('SIGTERM', async () => await oracledb.getPool().close());
process.once('SIGINT', async () => await oracledb.getPool().close());

async function withOracleDB(action) {
    let connection;
    try {
        connection = await oracledb.getConnection();
        return await action(connection);
    } finally {
        if (connection) await connection.close();
    }
}

async function runQuery(query, binds = [], options = {}) {
    return await withOracleDB(conn => conn.execute(query, binds, { autoCommit: true, ...options }));
}

async function getNextID(table, idField) {
    const result = await runQuery(`SELECT NVL(MAX(${idField}), 0) + 1 AS next FROM ${table}`);
    return result.rows[0][0];
}

async function testOracleConnection() {
    try {
        await withOracleDB(async (conn) => {
            await conn.execute('SELECT 1 FROM DUAL');
        });
        return true;
    } catch (err) {
        console.error('Test connection failed:', err.message);
        return false;
    }
}
async function getAllStudents() {
    const result = await runQuery('SELECT SID, Name FROM Student');
    return result.rows;
}
async function getOtherStudents(sid) {
    const result = await runQuery('SELECT SID, Name FROM Student WHERE SID != :sid', { sid });
    return result.rows;
}
async function getRatings() {
    // Return each rating page along with its current average rating and student ID.
    const result = await runQuery('SELECT PageID, AvgRating, SID FROM RatingPageHasStudent');
    return result.rows;
}

async function getStudentBySID(sid) {
    const result = await runQuery('SELECT SID, Name FROM Student WHERE SID = :sid', { sid });
    return result.rows.length > 0 ? { SID: result.rows[0][0], Name: result.rows[0][1] } : null;
}


async function registerStudent(name) {
    const sid = await getNextID('Student', 'SID');
    const pid = await getNextID('RatingPageHasStudent', 'PageID');
    await runQuery('INSERT INTO Student (SID, Name) VALUES (:sid, :name)', { sid, name });
    await runQuery('INSERT INTO RatingPageHasStudent (PageID, AvgRating, SID) VALUES (:pid, 0.00, :sid)', { pid, sid });
    return { sid, pid };
}

async function createGroup(name, creatorSID) {
    const gid = await getNextID('StudentGroup', 'GroupID');
    await runQuery('INSERT INTO StudentGroup (GroupID, GroupName) VALUES (:gid, :name)', { gid, name });
    await runQuery('INSERT INTO BelongsTo (GroupID, SID) VALUES (:gid, :sid)', { gid, sid: creatorSID });
    return { gid };
}

async function createSession(data) {
    const id = await getNextID('StudySession', 'SessionID');
    await runQuery(
        `INSERT INTO StudySession(SessionID, SessionName, ContentID, CreatorID, StartTime, EndTime, Location, ZoomLink, GroupID)
         VALUES (:id, :name, :content, :creator, TO_TIMESTAMP(:start, 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP(:end, 'YYYY-MM-DD HH24:MI:SS'), :loc, :zoom, :gid)`,
        {
            id,
            name: data.sessionName,
            content: data.contentID,
            creator: data.creatorID,
            start: data.startTime,
            end: data.endTime,
            loc: data.location,
            zoom: data.zoomLink,
            gid: data.groupID
        }
    );
    await runQuery('INSERT INTO Attends(SessionID, ParticipantID) VALUES (:id, :creator)', { id, creator: data.creatorID });
    return id;
}

async function joinSession(sessionID, studentID) {
    await runQuery('INSERT INTO Attends(SessionID, ParticipantID) VALUES (:sid, :pid)', { sid: sessionID, pid: studentID });
}

async function listSessions() {
    const result = await runQuery(
        `SELECT SessionID, SessionName, TO_CHAR(StartTime, 'YYYY-MM-DD HH24:MI:SS') AS StartTime, TO_CHAR(EndTime, 'YYYY-MM-DD HH24:MI:SS') AS EndTime FROM StudySession`
    );
    return result.rows;
}

async function listContents() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM CONTENT');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function giveRating(fromSID, toSID, ratingValue) {
    const reviewID = await getNextID('Review', 'ReviewID');
    const pageResult = await runQuery('SELECT PageID FROM RatingPageHasStudent WHERE SID = :sid', { sid: toSID });
    const pageID = pageResult.rows[0][0];

    await runQuery(
        'INSERT INTO Review(ReviewID, Rating, PageID, SID) VALUES (:reviewID, :rating, :pageID, :studentID)',
        { reviewID, rating: ratingValue, pageID, studentID: fromSID }
    );

    const result = await runQuery('SELECT AVG(Rating) FROM Review WHERE PageID = :pageID', { pageID });
    const newAvg = result.rows[0][0];

    await runQuery('UPDATE RatingPageHasStudent SET AvgRating = :avg WHERE PageID = :pageID', { avg: newAvg, pageID });
}

async function uploadResource({ url, type, name, groupID, uploaderID }) {
    const resourceID = await getNextID('StudyResource', 'ResourceID');

    await runQuery(
        `MERGE INTO ResourceType t
         USING (SELECT :url AS ResourceURL, :type AS FileType FROM dual) s
         ON (t.ResourceURL = s.ResourceURL)
         WHEN NOT MATCHED THEN INSERT (ResourceURL, FileType) VALUES (s.ResourceURL, s.FileType)`,
        { url, type }
    );

    await runQuery(
        `INSERT INTO StudyResource(ResourceID, ResourceName, GroupID, UploaderID, ResourceURL)
         VALUES (:id, :name, :gid, :uid, :url)`,
        { id: resourceID, name, gid: groupID, uid: uploaderID, url }
    );

    return { resourceID };
}

module.exports = {
    testOracleConnection,
    registerStudent,
    createGroup,
    createSession,
    joinSession,
    listSessions,
    listContents,
    giveRating,
    getAllStudents,
    getRatings,
    getStudentBySID,
    uploadResource,
    getOtherStudents
};