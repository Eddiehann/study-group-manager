/*
 * These functions below are for various webpage functionalities. 
 * Each function serves to process data on the frontend:
 *      - Before sending requests to the backend.
 *      - After receiving responses from the backend.
 * 
 * To tailor them to your specific needs,
 * adjust or expand these functions to match both your 
 *   backend endpoints 
 * and 
 *   HTML structure.
 * 
 */

// This function checks the database connection and updates its status on the frontend.
async function checkDbConnection() {
    const statusElem = document.getElementById('dbStatus');

    const response = await fetch('/check-db-connection', {
        method: "GET"
    });

    // Display the statusElem's text in the placeholder.
    statusElem.style.display = 'inline';

    response.text()
    .then((text) => {
        statusElem.textContent = text;
    })
    .catch((error) => {
        statusElem.textContent = 'connection timed out';  // Adjust error handling if required.
    });
}

// Fetches data from the student table and displays it.
async function fetchAndDisplayUsers() {
    const tableElement = document.getElementById('students');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/students', {
        method: 'GET'
    });

    const responseData = await response.json();
    const studentTableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    studentTableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// Inserts new records into the student table.
async function insertStudent(event) {
    event.preventDefault();

    const nameValue = document.getElementById('insertName').value;

    const response = await fetch('/register-student', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            name: nameValue
        })
    });

    const responseData = await response.json();
    const insertMsg = document.getElementById('insertResultMsg');

    if (responseData.success) {
        fetchTableData();
    } 
    insertMsg.textContent = responseData.message;
}

// Selects student from database and sets it as the current user.
async function selectStudent(event) {
    event.preventDefault();

    const sid = document.getElementById('insertSID').value;
    const selectMsg = document.getElementById('selectResultMsg');

    const response = await fetch(`/student/${sid}`);
    const responseData = await response.json();
    
    if (response.ok && responseData.success) {
        sessionStorage.setItem('selectedStudent', JSON.stringify({
            name: responseData.name,
            sid: sid
        }));
        selectMsg.textContent = `Selected: ${responseData.name} (SID: ${sid})`;
        fetchSelectedStudent();
    } else {
        sessionStorage.setItem('selectedStudent', null);
        selectMsg.textContent = responseData.message;
    }
}

// Update selected student on page switch
async function fetchSelectedStudent() {
    const selectStudent = document.getElementById('selectedStudent'); // null if not set
    const storedStudent = sessionStorage.getItem('selectedStudent');

    if (storedStudent) {
        const parsed = JSON.parse(storedStudent);
        const name = parsed.name;
        const sid = parsed.sid;

        selectStudent.textContent = `${name} (SID: ${sid})`;
    } else {
        selectStudent.textContent = "Not selected";
    }

    // hide or show the options after selecting a student
    const linksSection = document.getElementById('links');
    const selectedStudent = sessionStorage.getItem('selectedStudent');
    if (selectedStudent && linksSection) {
        linksSection.classList.remove('hidden');
    }
}

async function createGroup(event) {
    event.preventDefault();
    const currStudent = JSON.parse(sessionStorage.getItem('selectedStudent'));

    const nameValue = document.getElementById('insertGroupName').value;
    const sid = parseInt(currStudent.sid);


    console.log(nameValue, sid) 
    

    const response = await fetch('/create-group', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            groupName: nameValue,
            creatorSID: sid
        })
    });

    const responseData = await response.json();
    const insertMsg = document.getElementById('createGroupMsg');

    if (responseData.success) {
        fetchTableData();
    } 
    insertMsg.textContent = responseData.message;
}

// Fetches data from the ratings table and displays it.
async function fetchAndDisplayRatings() {
    const tableElement = document.getElementById('ratings');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/ratings', {
        method: 'GET'
    });

    const responseData = await response.json();
    const studentTableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    studentTableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

async function giveRating(event) {
    event.preventDefault();
    const currStudent = JSON.parse(sessionStorage.getItem('selectedStudent'));

    const toSID = parseInt(document.getElementById('ratingSID').value);
    const ratingValue = parseInt(document.getElementById('ratingValue').value);
    const fromSID = parseInt(currStudent.sid);

    const response = await fetch('/give-rating', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            fromSID: fromSID,
            ratingValue: ratingValue,
            toSID: toSID
        })
    });

    const responseData = await response.json();
    const insertMsg = document.getElementById('giveRatingMsg');

    if (responseData.success) {
        fetchTableData();
    } 
    insertMsg.textContent = responseData.message;
}

// // Fetches data from the sessions table and displays it.
// async function fetchAndDisplaySessions() {
//     const tableElement = document.getElementById('ratings');
//     const tableBody = tableElement.querySelector('tbody');

//     const response = await fetch('/ratings', {
//         method: 'GET'
//     });

//     const responseData = await response.json();
//     const studentTableContent = responseData.data;

//     // Always clear old, already fetched data before new fetching process.
//     if (tableBody) {
//         tableBody.innerHTML = '';
//     }

//     studentTableContent.forEach(user => {
//         const row = tableBody.insertRow();
//         user.forEach((field, index) => {
//             const cell = row.insertCell(index);
//             cell.textContent = field;
//         });
//     });
// }

// Fetches data from the content table and displays it.
async function fetchAndDisplayContents() {
    const tableElement = document.getElementById('contents');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/contents', {
        method: 'GET'
    });

    const responseData = await response.json();
    const studentTableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    studentTableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// drop down options for leaving ratings
async function populateStudentDropdown() {
    const dropdown = document.getElementById('ratingSID');
    
    const currStudent = JSON.parse(sessionStorage.getItem('selectedStudent'));
    const sid = parseInt(currStudent.sid);

    const response = await fetch(`/other-students/${sid}`,{
        method: 'GET'
    }); // return students excluding current user
    
    const students = await response.json();
    console.log('Fetched students:', students);
    const studentTableContent = students.data;

    studentTableContent.forEach(student => {
        const sid = student[0];
        const name = student[1];
        const option = document.createElement('option');
        option.value = sid;
        option.textContent = `${name} (SID: ${sid})`;
        dropdown.appendChild(option);
    });
}

// Call it on page load
window.addEventListener('DOMContentLoaded', populateStudentDropdown);


// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    checkDbConnection();
    fetchTableData();
    fetchSelectedStudent();
    if (document.getElementById("insertStudent")) document.getElementById("insertStudent").addEventListener("submit", insertStudent);
    if (document.getElementById("selectStudent")) document.getElementById("selectStudent").addEventListener("submit", selectStudent);
    if (document.getElementById("createGroup")) document.getElementById("createGroup").addEventListener("submit", createGroup);
    if (document.getElementById("giveRating")) document.getElementById("giveRating").addEventListener("submit", giveRating);
    if (document.getElementById("RatingSID")) populateStudentDropdown();
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    if (document.getElementById("students")) fetchAndDisplayUsers();
    if (document.getElementById("ratings")) fetchAndDisplayRatings();
    if (document.getElementById("contents")) fetchAndDisplayContents();
    //fetchAndDisplaySessions();
}
