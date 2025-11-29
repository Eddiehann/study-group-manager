
const express = require('express');
const appService = require('./appService');

const router = express.Router();

router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    res.send(isConnect ? 'connected' : 'unable to connect');
});

router.post('/register-student', async (req, res) => {
    const name = req.body.name;  // ✅ matches frontend
    try {
        const result = await appService.registerStudent(name);
        res.json({
            success: true,
            message: `Registered student with SID ${result.sid}. Created rating page ID ${result.pid}`,
            sid: result.sid,
            pid: result.pid
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: 'Error registering student'
        });
    }
});

router.post('/create-group', async (req, res) => {
    const { groupName, creatorSID } = req.body;
    try {
        const result = await appService.createGroup(groupName, creatorSID);
        res.json({
            success: true,
            message: `Created group with ID ${result.gid} and name ${groupName}. Student ${creatorSID} assigned to group.`,
            gid: result.gid
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: 'Error creating group'
        });
    }
});

router.post('/give-rating', async (req, res) => {
    const { fromSID, toSID, ratingValue } = req.body;
    try {
        await appService.giveRating(fromSID, toSID, ratingValue);
        res.json({
            success: true,
            message: `Rating recorded and average updated for student ${toSID}`
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({
            success: false,
            message: 'Error recording rating'
        });
    }
});

router.get('/students', async (req, res) => {
    try {
        const students = await appService.getAllStudents();
        res.json({ success: true, data: students });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Error fetching students' });
    }
});

router.get('/other-students/:sid', async (req, res) => {
    const sid = req.params.sid;
    try {
        const students = await appService.getOtherStudents(sid);
        res.json({ success: true, data: students });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Error fetching students' });
    }
});


router.get('/ratings', async (req, res) => {
    try {
        const ratings = await appService.getRatings();
        res.json({ success: true, data: ratings });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Error fetching ratings' });
    }
});


router.get('/student/:sid', async (req, res) => {
    const sid = req.params.sid;
    try {
        const result = await appService.getStudentBySID(sid);
        if (result) {
            res.json({ success: true, name: result.Name, sid: result.SID });
        } else {
            res.json({ success: false, message: 'Student not found' });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Error fetching student' });
    }
});

router.get('/contents', async (req, res) => {
    const tableContent = await appService.listContents();
    res.json({data: tableContent});
});


module.exports = router;