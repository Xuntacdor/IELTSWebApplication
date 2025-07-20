let listeningSectionCount = 0;
let sectionGroupIndex = {};
let sectionActiveGroups = {};
let listeningQuestionCounts = {};
let currentExamType = 'LISTENING_FULL';
let currentSection = 1;

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
        // Single mode - initialize single group container
        console.log("Single listening mode activated");
        initializeSingleMode();
    } else if (type === 'LISTENING_FULL') {
        // Start with 4 sections for full test
        for (let i = 1; i <= 4; i++) {
            addListeningSection(i);
        }
    }
}

function initializeSingleMode() {
    // Clear any existing single groups
    const singleGroupsContainer = document.getElementById('singleGroups');
    if (singleGroupsContainer) {
        singleGroupsContainer.innerHTML = '';
    }
    
    // Initialize single group index
    if (!window.singleGroupIndex) {
        window.singleGroupIndex = 1;
    }
}

function switchSection(sectionNumber) {
    currentSection = sectionNumber;
    
    // Update active button
    document.querySelectorAll('.section-btns button').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');
    
    // Update hidden input
    document.getElementById('sectionHidden').value = sectionNumber;
    
    // Show/hide section containers
    document.querySelectorAll('.section-container').forEach(container => {
        container.style.display = 'none';
    });
    
    const targetContainer = document.getElementById(`section-container-${sectionNumber}`);
    if (targetContainer) {
        targetContainer.style.display = 'block';
    }
}

function addListeningSection(sectionId = null) {
    if (currentExamType === 'LISTENING_SINGLE') return; // No sections for single mode
    
    if (sectionId === null) {
        sectionId = ++listeningSectionCount;
    }
    
    if (sectionId > 4) return; // Maximum 4 sections
    
    sectionGroupIndex[sectionId] = 1;
    sectionActiveGroups[sectionId] = new Set();
    listeningQuestionCounts[sectionId] = {};

    const container = document.getElementById("sections-container");

    const sectionDiv = document.createElement("div");
    sectionDiv.className = `section-container border p-3 mb-4 bg-light rounded ${sectionId === 1 ? '' : 'd-none'}`;
    sectionDiv.id = `section-container-${sectionId}`;
    
    let html = `
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4>🎧 Section ${sectionId}</h4>
            <span class="badge bg-primary">Section ${sectionId}</span>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <label>Section Title:</label>
                <input type="text" name="sectionTitle${sectionId}" class="form-control mb-2" placeholder="Enter section title" required>
            </div>
        </div>
        
        <div id="groupContainer_${sectionId}"></div>
        <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addListeningGroup(${sectionId})">
            ➕ Add Question Group
        </button>
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
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5>📝 Question Group ${groupIndex}</h5>
            <button type="button" class="btn btn-sm btn-danger" onclick="removeListeningGroup(${sectionId}, ${groupIndex})">
                🗑 Delete Group
            </button>
        </div>

        <div class="row">
            <div class="col-md-6">
                <label>Question Type:</label>
                <select name="groupType_${sectionId}_${groupIndex}" class="form-select mt-2" onchange="changeGroupType(${sectionId}, ${groupIndex}, this.value)">
                    <option value="MULTIPLE_CHOICE">Multiple Choice</option>
                    <option value="SUMMARY_COMPLETION">Summary Completion</option>
                    <option value="TABLE_COMPLETION">Table Completion</option>
                    <option value="FLOWCHART">Flowchart Completion</option>
                    <option value="FORM_COMPLETION">Form Completion</option>
                    <option value="NOTE_COMPLETION">Note Completion</option>
                    <option value="MAP_LABELING">Map Labeling</option>
                    <option value="PLAN_LABELING">Plan Labeling</option>
                    <option value="DIAGRAM_LABELING">Diagram Labeling</option>
                    <option value="SENTENCE_COMPLETION">Sentence Completion</option>
                    <option value="MATCHING">Matching</option>
                </select>
            </div>
            <div class="col-md-6">
                <label>Upload Image (optional):</label>
                <input type="file" name="groupImage_${sectionId}_${groupIndex}" class="form-control mb-2" accept="image/*">
            </div>
        </div>

        <label class="mt-2">Instruction (optional):</label>
        <textarea name="groupInstruction_${sectionId}_${groupIndex}" class="form-control" placeholder="Enter instructions for this question group"></textarea>

        <div id="questions-container-${sectionId}-${groupIndex}" class="mt-3"></div>
        <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addListeningQuestion(${sectionId}, ${groupIndex})">
            ➕ Add Question
        </button>
    `;
    
    container.appendChild(div);
    changeGroupType(sectionId, groupIndex, "MULTIPLE_CHOICE");
}

function removeListeningGroup(sectionId, groupIndex) {
    const element = document.getElementById(`group-${sectionId}-${groupIndex}`);
    if (element) {
        element.remove();
        sectionActiveGroups[sectionId].delete(groupIndex);
        delete listeningQuestionCounts[sectionId][groupIndex];
    }
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
        <div class="question-block border p-3 position-relative mt-3 bg-light rounded" id="q-${sectionId}-${groupIndex}-${questionId}">
            <button type="button" class="btn-close position-absolute end-0 top-0" onclick="removeListeningQuestion(${sectionId}, ${groupIndex}, ${questionId})"></button>
            <h6>Question ${getQuestionNumber(sectionId, groupIndex, questionId)}</h6>
    `;

    switch (type) {
        case "MULTIPLE_CHOICE":
            html += `
                <label>Question Text:</label>
                <input type="text" name="q_${sectionId}_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter question text" required>
                <div id="options_${sectionId}_${groupIndex}_${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addListeningOption(${sectionId}, ${groupIndex}, ${questionId})">
                    ➕ Add Option
                </button>
            `;
            break;
            
        case "MATCHING":
            html += `
                <div id="matching-pairs-${sectionId}-${groupIndex}-${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addMatchingPair(${sectionId}, ${groupIndex}, ${questionId})">
                    ➕ Add Matching Pair
                </button>
            `;
            break;
            
        case "SUMMARY_COMPLETION":
        case "TABLE_COMPLETION":
        case "FLOWCHART":
        case "FORM_COMPLETION":
        case "NOTE_COMPLETION":
            html += `
                <div id="completion-lines-${sectionId}-${groupIndex}-${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addCompletionLine(${sectionId}, ${groupIndex}, ${questionId})">
                    ➕ Add Completion Line
                </button>
            `;
            break;
            
        case "MAP_LABELING":
        case "PLAN_LABELING":
        case "DIAGRAM_LABELING":
            html += `
                <label>Label ${questionId}:</label>
                <input type="text" name="labelQ_${sectionId}_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter label text" required>
                <label>Correct Answer:</label>
                <input type="text" name="labelA_${sectionId}_${groupIndex}_${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
            break;
            
        case "SENTENCE_COMPLETION":
            html += `
                <label>Sentence ${questionId}:</label>
                <input type="text" name="sentenceQ_${sectionId}_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter sentence with blank" required>
                <label>Correct Answer:</label>
                <input type="text" name="sentenceA_${sectionId}_${groupIndex}_${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
            break;
            
        default:
            html += `
                <label>Question ${questionId}:</label>
                <input type="text" name="q_${sectionId}_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter question text" required>
                <label>Answer:</label>
                <input type="text" name="shortA_${sectionId}_${groupIndex}_${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
    }

    html += `</div>`;
    container.insertAdjacentHTML("beforeend", html);

    // Add default content based on type
    switch (type) {
        case "MULTIPLE_CHOICE":
            for (let i = 0; i < 4; i++) {
                addListeningOption(sectionId, groupIndex, questionId);
            }
            break;
        case "MATCHING":
            addMatchingPair(sectionId, groupIndex, questionId);
            break;
        case "SUMMARY_COMPLETION":
        case "TABLE_COMPLETION":
        case "FLOWCHART":
        case "FORM_COMPLETION":
        case "NOTE_COMPLETION":
            addCompletionLine(sectionId, groupIndex, questionId);
            break;
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

function addMatchingPair(sectionId, groupIndex, questionId) {
    const container = document.getElementById(`matching-pairs-${sectionId}-${groupIndex}-${questionId}`);
    const index = container?.children.length || 0;

    const pairHtml = `
        <div class="row mb-2 matching-pair align-items-center">
            <div class="col-md-5">
                <input type="text" name="matchQ_${sectionId}_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Left item" required>
            </div>
            <div class="col-md-5">
                <input type="text" name="matchA_${sectionId}_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Right item" required>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeMatchingPair(this)">🗑 Remove</button>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML("beforeend", pairHtml);
}

function addCompletionLine(sectionId, groupIndex, questionId) {
    const container = document.getElementById(`completion-lines-${sectionId}-${groupIndex}-${questionId}`);
    const index = container?.children.length || 0;

    const lineHtml = `
        <div class="row mb-2 completion-line align-items-center">
            <div class="col-md-8">
                <input type="text" name="q_${sectionId}_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Question/Text with blank" required>
            </div>
            <div class="col-md-3">
                <input type="text" name="shortA_${sectionId}_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Answer" required>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeCompletionLine(this)">🗑</button>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML("beforeend", lineHtml);
}

function removeListeningOption(btn) {
    btn.closest('.option-row')?.remove();
}

function removeMatchingPair(btn) {
    btn.closest('.matching-pair')?.remove();
}

function removeCompletionLine(btn) {
    btn.closest('.completion-line')?.remove();
}

function addSingleGroup() {
    if (!window.singleGroupIndex) {
        window.singleGroupIndex = 1;
    }
    
    const groupIndex = window.singleGroupIndex++;
    const container = document.getElementById('singleGroups');
    
    const div = document.createElement("div");
    div.className = "question-group border p-3 mb-3 bg-white rounded";
    div.id = `single-group-${groupIndex}`;

    div.innerHTML = `
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5>📝 Question Group ${groupIndex}</h5>
            <button type="button" class="btn btn-sm btn-danger" onclick="removeSingleGroup(${groupIndex})">
                🗑 Delete Group
            </button>
        </div>

        <div class="row">
            <div class="col-md-6">
                <label>Question Type:</label>
                <select name="groupType_${groupIndex}" class="form-select mt-2" onchange="changeSingleGroupType(${groupIndex}, this.value)">
                    <option value="MULTIPLE_CHOICE">Multiple Choice</option>
                    <option value="SUMMARY_COMPLETION">Summary Completion</option>
                    <option value="TABLE_COMPLETION">Table Completion</option>
                    <option value="FLOWCHART">Flowchart Completion</option>
                    <option value="FORM_COMPLETION">Form Completion</option>
                    <option value="NOTE_COMPLETION">Note Completion</option>
                    <option value="MAP_LABELING">Map Labeling</option>
                    <option value="PLAN_LABELING">Plan Labeling</option>
                    <option value="DIAGRAM_LABELING">Diagram Labeling</option>
                    <option value="SENTENCE_COMPLETION">Sentence Completion</option>
                    <option value="MATCHING">Matching</option>
                </select>
            </div>
            <div class="col-md-6">
                <label>Upload Image (optional):</label>
                <input type="file" name="groupImage_${groupIndex}" class="form-control mb-2" accept="image/*">
            </div>
        </div>

        <label class="mt-2">Instruction (optional):</label>
        <textarea name="groupInstruction_${groupIndex}" class="form-control" placeholder="Enter instructions for this question group"></textarea>

        <div id="single-questions-container-${groupIndex}" class="mt-3"></div>
        <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addSingleQuestion(${groupIndex})">
            ➕ Add Question
        </button>
    `;
    
    container.appendChild(div);
    changeSingleGroupType(groupIndex, "MULTIPLE_CHOICE");
}

function removeSingleGroup(groupIndex) {
    const element = document.getElementById(`single-group-${groupIndex}`);
    if (element) {
        element.remove();
    }
}

function changeSingleGroupType(groupIndex, type) {
    const container = document.getElementById(`single-questions-container-${groupIndex}`);
    container.innerHTML = '';
    addSingleQuestion(groupIndex); // Add first question by default
}

function addSingleQuestion(groupIndex) {
    if (!window.nextSingleQuestionId) window.nextSingleQuestionId = {};
    if (!window.nextSingleQuestionId[groupIndex]) window.nextSingleQuestionId[groupIndex] = 1;

    const questionId = window.nextSingleQuestionId[groupIndex]++;
    const type = document.querySelector(`[name="groupType_${groupIndex}"]`).value;
    const container = document.getElementById(`single-questions-container-${groupIndex}`);

    let html = `
        <div class="question-block border p-3 position-relative mt-3 bg-light rounded" id="single-q-${groupIndex}-${questionId}">
            <button type="button" class="btn-close position-absolute end-0 top-0" onclick="removeSingleQuestion(${groupIndex}, ${questionId})"></button>
            <h6>Question ${questionId}</h6>
    `;

    switch (type) {
        case "MULTIPLE_CHOICE":
            html += `
                <label>Question Text:</label>
                <input type="text" name="q_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter question text" required>
                <div id="single-options_${groupIndex}_${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addSingleOption(${groupIndex}, ${questionId})">
                    ➕ Add Option
                </button>
            `;
            break;
            
        case "MATCHING":
            html += `
                <div id="single-matching-pairs-${groupIndex}-${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addSingleMatchingPair(${groupIndex}, ${questionId})">
                    ➕ Add Matching Pair
                </button>
            `;
            break;
            
        case "SUMMARY_COMPLETION":
        case "TABLE_COMPLETION":
        case "FLOWCHART":
        case "FORM_COMPLETION":
        case "NOTE_COMPLETION":
            html += `
                <div id="single-completion-lines-${groupIndex}-${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addSingleCompletionLine(${groupIndex}, ${questionId})">
                    ➕ Add Completion Line
                </button>
            `;
            break;
            
        case "MAP_LABELING":
        case "PLAN_LABELING":
        case "DIAGRAM_LABELING":
            html += `
                <label>Label ${questionId}:</label>
                <input type="text" name="labelQ_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter label text" required>
                <label>Correct Answer:</label>
                <input type="text" name="labelA_${groupIndex}_${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
            break;
            
        case "SENTENCE_COMPLETION":
            html += `
                <label>Sentence ${questionId}:</label>
                <input type="text" name="sentenceQ_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter sentence with blank" required>
                <label>Correct Answer:</label>
                <input type="text" name="sentenceA_${groupIndex}_${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
            break;
            
        default:
            html += `
                <label>Question ${questionId}:</label>
                <input type="text" name="q_${groupIndex}_${questionId}" class="form-control mb-2" placeholder="Enter question text" required>
                <label>Answer:</label>
                <input type="text" name="shortA_${groupIndex}_${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
    }

    html += `</div>`;
    container.insertAdjacentHTML("beforeend", html);

    // Add default content based on type
    switch (type) {
        case "MULTIPLE_CHOICE":
            for (let i = 0; i < 4; i++) {
                addSingleOption(groupIndex, questionId);
            }
            break;
        case "MATCHING":
            addSingleMatchingPair(groupIndex, questionId);
            break;
        case "SUMMARY_COMPLETION":
        case "TABLE_COMPLETION":
        case "FLOWCHART":
        case "FORM_COMPLETION":
        case "NOTE_COMPLETION":
            addSingleCompletionLine(groupIndex, questionId);
            break;
    }
}

function addSingleOption(groupIndex, questionId) {
    const container = document.getElementById(`single-options_${groupIndex}_${questionId}`);
    const index = container?.children.length || 0;

    const optHtml = `
        <div class="row mb-2 option-row align-items-center">
            <div class="col-md-6">
                <input type="text" name="a_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Option ${String.fromCharCode(65 + index)}" required>
            </div>
            <div class="col-md-2 d-flex align-items-center">
                <input class="form-check-input me-1" type="checkbox" name="correct_${groupIndex}_${questionId}_${index}">
                <label class="form-check-label ms-1">Correct</label>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeListeningOption(this)">🗑 Remove</button>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML("beforeend", optHtml);
}

function addSingleMatchingPair(groupIndex, questionId) {
    const container = document.getElementById(`single-matching-pairs-${groupIndex}-${questionId}`);
    const index = container?.children.length || 0;

    const pairHtml = `
        <div class="row mb-2 matching-pair align-items-center">
            <div class="col-md-5">
                <input type="text" name="matchQ_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Left item" required>
            </div>
            <div class="col-md-5">
                <input type="text" name="matchA_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Right item" required>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeMatchingPair(this)">🗑 Remove</button>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML("beforeend", pairHtml);
}

function addSingleCompletionLine(groupIndex, questionId) {
    const container = document.getElementById(`single-completion-lines-${groupIndex}-${questionId}`);
    const index = container?.children.length || 0;

    const lineHtml = `
        <div class="row mb-2 completion-line align-items-center">
            <div class="col-md-8">
                <input type="text" name="q_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Question/Text with blank" required>
            </div>
            <div class="col-md-3">
                <input type="text" name="shortA_${groupIndex}_${questionId}_${index}" class="form-control" placeholder="Answer" required>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeCompletionLine(this)">🗑</button>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML("beforeend", lineHtml);
}

function removeSingleQuestion(groupIndex, questionId) {
    const element = document.getElementById(`single-q-${groupIndex}-${questionId}`);
    if (element) {
        element.remove();
    }
}

function removeListeningQuestion(sectionId, groupIndex, questionId) {
    const element = document.getElementById(`q-${sectionId}-${groupIndex}-${questionId}`);
    if (element) {
        element.remove();
        listeningQuestionCounts[sectionId][groupIndex] = listeningQuestionCounts[sectionId][groupIndex].filter(id => id !== questionId);
    }
}

function getQuestionNumber(sectionId, groupIndex, questionId) {
    const arr = listeningQuestionCounts[sectionId][groupIndex];
    return arr.indexOf(questionId) + 1;
}

// Initialize the form when page loads
window.onload = () => {
    const examType = document.getElementById('examType');
    if (examType) {
        examType.addEventListener('change', function() {
            setExamType(this.value);
        });
        
        // Set initial state
        if (examType.value) {
            setExamType(examType.value);
        } else {
            setExamType('LISTENING_FULL');
        }
    }
    
    // Set first section as active
    switchSection(1);
};
