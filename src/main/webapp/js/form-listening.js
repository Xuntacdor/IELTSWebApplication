let listeningSectionCount = 0;
let sectionGroupIndex = {};
let sectionActiveGroups = {};
let listeningQuestionCounts = {};
// Thêm biến để theo dõi loại bài test
let currentExamType = 'LISTENING_FULL';

function resetSections() {
    listeningSectionCount = 0;
    sectionGroupIndex = {};
    sectionActiveGroups = {};
    listeningQuestionCounts = {};
    const container = document.getElementById("sections-container");
    if (container) container.innerHTML = '';
}

function setExamType(type) {
    currentExamType = type;
    resetSections();
    if (type === 'LISTENING_SINGLE') {
        addListeningSection(true); // single mode
    } else {
        for (let i = 1; i <= 1; i++) addListeningSection(false); // start with 1 section for full, user có thể add thêm
    }
}

function addListeningSection(isSingle = false) {
    if (currentExamType === 'LISTENING_SINGLE' && listeningSectionCount >= 1) return; // chỉ 1 section cho single
    if (currentExamType === 'LISTENING_FULL' && listeningSectionCount >= 4) return; // tối đa 4 section cho full
    listeningSectionCount++;
    const sectionId = listeningSectionCount;
    sectionGroupIndex[sectionId] = 1;
    sectionActiveGroups[sectionId] = new Set();
    listeningQuestionCounts[sectionId] = {};

    const container = document.getElementById("sections-container");

    const sectionDiv = document.createElement("div");
    sectionDiv.className = "border p-3 mb-4 bg-light rounded";
    let html = `<h4>🎧 Section ${sectionId}</h4>`;
    html += `
        <label>Section Name:</label>
        <select name="sectionName${sectionId}" class="form-select mb-2" required>
            <option value="Ex1">Ex 1</option>
            <option value="Ex2">Ex 2</option>
            <option value="Ex3">Ex 3</option>
            <option value="Ex4">Ex 4</option>
        </select>
    `;
    if (currentExamType === 'LISTENING_FULL') {
        html += `
            <label>Section Title:</label>
            <input type="text" name="sectionTitle${sectionId}" class="form-control mb-2" required>
        `;
    }
    html += `<div id="groupContainer_${sectionId}"></div>
        <button type="button" class="btn btn-sm btn-outline-primary" onclick="addListeningGroup(${sectionId})">➕ Add Question Group</button>
    `;
    sectionDiv.innerHTML = html;
    container.appendChild(sectionDiv);
}

function addListeningGroup(sectionId) {
    const groupIndex = sectionGroupIndex[sectionId]++;
    sectionActiveGroups[sectionId].add(groupIndex);
    listeningQuestionCounts[sectionId][groupIndex] = [];

    const container = document.getElementById(`groupContainer_${sectionId}`);
    const div = document.createElement("div");
    div.className = "question-group border p-3 mb-3 bg-white rounded";
    div.id = `group-${sectionId}-${groupIndex}`;

    div.innerHTML = `
        <div class="d-flex justify-content-between align-items-center">
            <h5>Question Group</h5>
            <button type="button" class="btn btn-sm btn-danger" onclick="removeListeningGroup(${sectionId}, ${groupIndex})">🗑 Delete</button>
        </div>

        <label>Type:</label>
        <select name="groupType_${sectionId}_${groupIndex}" class="form-select mt-2" onchange="changeGroupType(${sectionId}, ${groupIndex}, this.value)">
            <option value="MULTIPLE_CHOICE">Multiple Choice</option>
            <option value="SUMMARY_COMPLETION">Summary Completion</option>
            <option value="TABLE_COMPLETION">Table Completion</option>
            <option value="FLOWCHART">Flowchart</option>
        </select>

        <label class="mt-2">Instruction (optional):</label>
        <textarea name="groupInstruction_${sectionId}_${groupIndex}" class="form-control"></textarea>

        <label class="mt-2">Upload Image (optional):</label>
        <input type="file" name="groupImage_${sectionId}_${groupIndex}" class="form-control mb-2" accept="image/*">

        <div id="questions-container-${sectionId}-${groupIndex}"></div>
        <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addListeningQuestion(${sectionId}, ${groupIndex})">➕ Add Question</button>
    `;
    container.appendChild(div);
    changeGroupType(sectionId, groupIndex, "MULTIPLE_CHOICE");
}

function removeListeningGroup(sectionId, groupIndex) {
    document.getElementById(`group-${sectionId}-${groupIndex}`)?.remove();
    sectionActiveGroups[sectionId].delete(groupIndex);
    delete listeningQuestionCounts[sectionId][groupIndex];
}

function changeGroupType(sectionId, groupIndex, type) {
    listeningQuestionCounts[sectionId][groupIndex] = [];
    const container = document.getElementById(`questions-container-${sectionId}-${groupIndex}`);
    container.innerHTML = '';
    addListeningQuestion(sectionId, groupIndex); // Add first question by default
}

function addListeningQuestion(sectionId, groupIndex) {
    if (!window.nextListeningQuestionId) window.nextListeningQuestionId = {};
    if (!window.nextListeningQuestionId[sectionId]) window.nextListeningQuestionId[sectionId] = {};
    if (!window.nextListeningQuestionId[sectionId][groupIndex]) window.nextListeningQuestionId[sectionId][groupIndex] = 1;

    const questionId = window.nextListeningQuestionId[sectionId][groupIndex]++;
    listeningQuestionCounts[sectionId][groupIndex].push(questionId);

    const type = document.querySelector(`[name="groupType_${sectionId}_${groupIndex}"]`).value;
    const container = document.getElementById(`questions-container-${sectionId}-${groupIndex}`);

    let html = `
        <div class="question-block border p-2 position-relative mt-3 bg-light rounded" id="q-${sectionId}-${groupIndex}-${questionId}">
            <button type="button" class="btn-close position-absolute end-0 top-0" onclick="removeListeningQuestion(${sectionId}, ${groupIndex}, ${questionId})"></button>
            <h6>Question ${getQuestionNumber(sectionId, groupIndex, questionId)}</h6>
    `;

    if (type === "MULTIPLE_CHOICE") {
        html += `
            <label>Question Text:</label>
            <input type="text" name="q_${sectionId}_${groupIndex}_${questionId}" class="form-control mb-2" required>
            <div id="options_${sectionId}_${groupIndex}_${questionId}"></div>
            <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addListeningOption(${sectionId}, ${groupIndex}, ${questionId})">➕ Add Option</button>
        `;
    } else if (type === "SUMMARY_COMPLETION") {
        html += `
            <div id="summary-lines-${sectionId}-${groupIndex}-${questionId}"></div>
            <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addSummaryLine('${sectionId}', '${groupIndex}', '${questionId}')">➕ Add Line</button>
        `;
    } else if (["TABLE_COMPLETION", "FLOWCHART"].includes(type)) {
        html += `
            <label>Answer ${questionId}:</label>
            <input type="text" name="imageQ_${sectionId}_${groupIndex}_${questionId}" class="form-control" placeholder="Correct label / answer">
        `;
    }

    html += `</div>`;
    container.insertAdjacentHTML("beforeend", html);

    if (type === "MULTIPLE_CHOICE") {
        for (let i = 0; i < 4; i++) {
            addListeningOption(sectionId, groupIndex, questionId);
        }
    } else if (type === "SUMMARY_COMPLETION") {
        // Thêm 1 dòng mặc định
        addSummaryLine(sectionId, groupIndex, questionId);
    }
}

function addListeningOption(sectionId, groupIndex, questionId) {
    const container = document.getElementById(`options_${sectionId}_${groupIndex}_${questionId}`);
    const index = container?.children.length || 0;

    const optHtml = `
        <div class="row mb-2 option-row align-items-center">
            <div class="col-md-6">
                <input type="text" name="a_${sectionId}_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Option ${String.fromCharCode(65 + index)}" required>
            </div>
            <div class="col-md-2 d-flex align-items-center">
                <input class="form-check-input me-1" type="checkbox" name="correct_${sectionId}_${groupIndex}_${questionId}_${index}">
                <label class="form-check-label ms-1">Correct</label>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeListeningOption(this)">🗑 Remove</button>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML("beforeend", optHtml);
}

function removeListeningOption(btn) {
    btn.closest('.option-row')?.remove();
}

function removeListeningQuestion(sectionId, groupIndex, questionId) {
    document.getElementById(`q-${sectionId}-${groupIndex}-${questionId}`)?.remove();
    listeningQuestionCounts[sectionId][groupIndex] = listeningQuestionCounts[sectionId][groupIndex].filter(id => id !== questionId);
}

// Hàm tự động render input đáp án cho các blank trong SUMMARY_COMPLETION
function renderSummaryBlanks(textarea, sectionId, groupIndex, questionId) {
    const value = textarea.value;
    // Tìm tất cả [blankX]
    const regex = /\[blank(\d+)\]/g;
    let match;
    let blanks = [];
    while ((match = regex.exec(value)) !== null) {
        blanks.push(match[1]);
    }
    // Loại bỏ trùng lặp
    blanks = [...new Set(blanks)];
    const container = document.getElementById(`summary-blanks-${sectionId}-${groupIndex}-${questionId}`);
    let html = '';
    blanks.forEach(idx => {
        html += `<div class="mb-2"><label>Answer for blank${idx}:</label><input type="text" name="shortA_${sectionId}_${groupIndex}_${questionId}_${idx}" class="form-control" required></div>`;
    });
    container.innerHTML = html;
}

function addSummaryLine(sectionId, groupIndex, questionId) {
    const container = document.getElementById(`summary-lines-${sectionId}-${groupIndex}-${questionId}`);
    if (!container) return;
    const lineCount = container.children.length + 1;
    const lineId = `line${lineCount}_${Date.now()}`;
    const html = `
        <div class="row mb-2 align-items-center" id="${lineId}">
            <div class="col-8">
                <input type="text" name="q_${sectionId}_${groupIndex}_${questionId}_${lineCount}" class="form-control" placeholder="Question line ${lineCount}" required>
            </div>
            <div class="col-3">
                <input type="text" name="shortA_${sectionId}_${groupIndex}_${questionId}_${lineCount}" class="form-control" placeholder="Answer ${lineCount}" required>
            </div>
            <div class="col-1">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeSummaryLine('${lineId}')">🗑</button>
            </div>
        </div>
    `;
    container.insertAdjacentHTML("beforeend", html);
}

function removeSummaryLine(lineId) {
    const el = document.getElementById(lineId);
    if (el) el.remove();
}

function getQuestionNumber(sectionId, groupIndex, questionId) {
    // Đảm bảo Question 1 là câu đầu tiên
    const arr = listeningQuestionCounts[sectionId][groupIndex];
    return arr.indexOf(questionId) + 1;
}

window.onload = () => {
    const examType = document.getElementById('examType');
    if (examType) {
        examType.addEventListener('change', function() {
            setExamType(this.value);
        });
        setExamType(examType.value || 'LISTENING_FULL');
    }
    addListeningSection(); // Initial call to add a section if no examType is set
};
