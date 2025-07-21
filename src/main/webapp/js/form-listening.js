// Global state management
const state = {
    listeningSectionCount: 0,
    sectionGroupIndex: {},
    sectionActiveGroups: {},
    listeningQuestionCounts: {},
    currentExamType: 'LISTENING_FULL',
    currentSection: 1,
    nextQuestionIds: {},
    singleGroupIndex: 1
};

// Question types configuration
const QUESTION_TYPES = {
    MULTIPLE_CHOICE: 'MULTIPLE_CHOICE',
    SUMMARY_COMPLETION: 'SUMMARY_COMPLETION',
    TABLE_COMPLETION: 'TABLE_COMPLETION',
    FLOWCHART: 'FLOWCHART',
    FORM_COMPLETION: 'FORM_COMPLETION',
    NOTE_COMPLETION: 'NOTE_COMPLETION',
    MAP_LABELING: 'MAP_LABELING',
    PLAN_LABELING: 'PLAN_LABELING',
    DIAGRAM_LABELING: 'DIAGRAM_LABELING',
    SENTENCE_COMPLETION: 'SENTENCE_COMPLETION',
    MATCHING: 'MATCHING'
};

// Utility functions
const utils = {
    resetSections() {
        Object.assign(state, {
            listeningSectionCount: 0,
            sectionGroupIndex: {},
            sectionActiveGroups: {},
            listeningQuestionCounts: {}
        });
        const container = document.getElementById("sections-container");
        if (container)
            container.innerHTML = '';
    },

    getNextQuestionId(sectionId, groupIndex) {
        if (!state.nextQuestionIds[sectionId])
            state.nextQuestionIds[sectionId] = {};
        if (!state.nextQuestionIds[sectionId][groupIndex])
            state.nextQuestionIds[sectionId][groupIndex] = 1;
        return state.nextQuestionIds[sectionId][groupIndex]++;
    },

    getSingleNextQuestionId(groupIndex) {
        if (!state.nextQuestionIds.single)
            state.nextQuestionIds.single = {};
        if (!state.nextQuestionIds.single[groupIndex])
            state.nextQuestionIds.single[groupIndex] = 1;
        return state.nextQuestionIds.single[groupIndex]++;
    },

    saveQuestionData(container) {
        const data = {};
        const questions = container.querySelectorAll('.question-block');
        questions.forEach((questionBlock, index) => {
            const questionId = questionBlock.id.split('-').pop();
            data[questionId] = {};
            questionBlock.querySelectorAll('input, textarea, select').forEach(input => {
                if (input.name && input.value) {
                    data[questionId][input.name] = input.value;
                }
            });
        });
        return data;
    },

    restoreQuestionData(questionBlock, data) {
        if (!questionBlock || !data)
            return;
        Object.keys(data).forEach(inputName => {
            const input = questionBlock.querySelector(`[name="${inputName}"]`);
            if (input)
                input.value = data[inputName];
        });
    }
};

// Core functions
function setExamType(type) {
    state.currentExamType = type;
    utils.resetSections();

    if (type === 'LISTENING_SINGLE') {
        console.log("Single listening mode activated");
        initializeSingleMode();
    } else if (type === 'LISTENING_FULL') {
        for (let i = 1; i <= 4; i++) {
            addListeningSection(i);
        }
    }
}

function initializeSingleMode() {
    const container = document.getElementById('singleGroups');
    if (container)
        container.innerHTML = '';
    if (!state.singleGroupIndex)
        state.singleGroupIndex = 1;
}

function switchSection(sectionNumber) {
    state.currentSection = sectionNumber;

    // Update active button
    document.querySelectorAll('.section-btns button').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');

    // Update hidden input
    document.getElementById('sectionHidden').value = sectionNumber;

    // Show/hide section containers
    document.querySelectorAll('.section-container').forEach(container => {
        container.style.display = 'none';
    });

    const targetContainer = document.getElementById(`section-container-${sectionNumber}`);
    if (targetContainer)
        targetContainer.style.display = 'block';
}

function addListeningSection(sectionId = null) {
    if (state.currentExamType === 'LISTENING_SINGLE' || sectionId > 4)
        return;

    if (sectionId === null)
        sectionId = ++state.listeningSectionCount;

    state.sectionGroupIndex[sectionId] = 1;
    state.sectionActiveGroups[sectionId] = new Set();
    state.listeningQuestionCounts[sectionId] = {};

    const container = document.getElementById("sections-container");
    const sectionDiv = document.createElement("div");
    sectionDiv.className = `section-container border p-3 mb-4 bg-light rounded ${sectionId === 1 ? '' : 'd-none'}`;
    sectionDiv.id = `section-container-${sectionId}`;

    sectionDiv.innerHTML = `
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

    container.appendChild(sectionDiv);
}

function addListeningGroup(sectionId) {
    const groupIndex = state.sectionGroupIndex[sectionId] || 1;
    state.sectionGroupIndex[sectionId] = groupIndex + 1;

    // ✅ FIX: đảm bảo khởi tạo Set nếu chưa có
    if (!state.sectionActiveGroups[sectionId]) {
        state.sectionActiveGroups[sectionId] = new Set();
    }
    if (!state.listeningQuestionCounts[sectionId]) {
        state.listeningQuestionCounts[sectionId] = {};
    }

    state.sectionActiveGroups[sectionId].add(groupIndex);
    state.listeningQuestionCounts[sectionId][groupIndex] = [];

    const container = document.getElementById(`groupContainer_${sectionId}`);
    const div = document.createElement("div");
    div.className = "question-group border p-3 mb-3 bg-white rounded";
    div.id = `group-${sectionId}-${groupIndex}`;

    div.innerHTML = createGroupHTML(sectionId, groupIndex, false);
    container.appendChild(div);
    changeGroupType(sectionId, groupIndex, "MULTIPLE_CHOICE");
}
function addSingleGroup() {
    const groupIndex = state.singleGroupIndex++;
    const container = document.getElementById('singleGroups');

    const div = document.createElement("div");
    div.className = "question-group border p-3 mb-3 bg-white rounded";
    div.id = `single-group-${groupIndex}`;

    div.innerHTML = createGroupHTML(null, groupIndex, true);

    container.appendChild(div);
    changeSingleGroupType(groupIndex, "MULTIPLE_CHOICE");
}

function createGroupHTML(sectionId, groupIndex, isSingle) {
    const prefix = isSingle ? '' : `${sectionId}_`;
    const removeFunc = isSingle ? `removeSingleGroup(${groupIndex})` : `removeListeningGroup(${sectionId}, ${groupIndex})`;
    const changeFunc = isSingle ? `changeSingleGroupType(${groupIndex}, this.value)` : `changeGroupType(${sectionId}, ${groupIndex}, this.value)`;
    const addQuestionFunc = isSingle ? `addSingleQuestion(${groupIndex})` : `addListeningQuestion(${sectionId}, ${groupIndex})`;
    const questionsContainerId = isSingle ? `single-questions-container-${groupIndex}` : `questions-container-${sectionId}-${groupIndex}`;

    return `
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5>📝 Question Group ${groupIndex}</h5>
            <button type="button" class="btn btn-sm btn-danger" onclick="${removeFunc}">
                🗑 Delete Group
            </button>
        </div>
        <div class="row">
            <div class="col-md-6">
                <label>Question Type:</label>
                <select name="groupType_${prefix}${groupIndex}" class="form-select mt-2" onchange="${changeFunc}">
                    ${Object.values(QUESTION_TYPES).map(type =>
            `<option value="${type}">${type.replace(/_/g, ' ')}</option>`
    ).join('')}
                </select>
            </div>
            <div class="col-md-6">
                <label>Upload Image (optional):</label>
                <input type="file" name="groupImage_${prefix}${groupIndex}" class="form-control mb-2" accept="image/*">
            </div>
        </div>
        <label class="mt-2">Instruction (optional):</label>
        <textarea name="groupInstruction_${prefix}${groupIndex}" class="form-control" placeholder="Enter instructions for this question group"></textarea>
        <div id="${questionsContainerId}" class="mt-3"></div>
        <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="${addQuestionFunc}">
            ➕ Add Question
        </button>
    `;
}

function removeListeningGroup(sectionId, groupIndex) {
    const element = document.getElementById(`group-${sectionId}-${groupIndex}`);
    if (element) {
        element.remove();
        state.sectionActiveGroups[sectionId].delete(groupIndex);
        delete state.listeningQuestionCounts[sectionId][groupIndex];
    }
}

function removeSingleGroup(groupIndex) {
    const element = document.getElementById(`single-group-${groupIndex}`);
    if (element)
        element.remove();
}

function changeGroupType(sectionId, groupIndex, type) {
    const container = document.getElementById(`questions-container-${sectionId}-${groupIndex}`);
    const questionData = utils.saveQuestionData(container);
    const questionCount = container.querySelectorAll('.question-block').length;

    container.innerHTML = '';
    if (state.nextQuestionIds[sectionId] && state.nextQuestionIds[sectionId][groupIndex]) {
        state.nextQuestionIds[sectionId][groupIndex] = 1;
    }
    // Restore questions with same count
    for (let i = 0; i < questionCount; i++) {
        const questionId = addListeningQuestion(sectionId, groupIndex);
        setTimeout(() => {
            const questionBlock = document.getElementById(`q-${sectionId}-${groupIndex}-${questionId}`);
            utils.restoreQuestionData(questionBlock, questionData[i + 1] || {});
        }, 50);
    }

    if (questionCount === 0)
        addListeningQuestion(sectionId, groupIndex);
    updateQuestionNumbers(sectionId, groupIndex, false);
}

function changeSingleGroupType(groupIndex, type) {
    const container = document.getElementById(`single-questions-container-${groupIndex}`);
    const questionData = utils.saveQuestionData(container);
    const questionCount = container.querySelectorAll('.question-block').length;

    container.innerHTML = '';
    if (state.nextQuestionIds.single && state.nextQuestionIds.single[groupIndex]) {
        state.nextQuestionIds.single[groupIndex] = 1;
    }
    for (let i = 0; i < questionCount; i++) {
        const questionId = addSingleQuestion(groupIndex);
        setTimeout(() => {
            const questionBlock = document.getElementById(`single-q-${groupIndex}-${questionId}`);
            utils.restoreQuestionData(questionBlock, questionData[i + 1] || {});
        }, 100);
    }

    if (questionCount === 0)
        addSingleQuestion(groupIndex);
    updateQuestionNumbers(null, groupIndex, true);
}

function addListeningQuestion(sectionId, groupIndex) {
    const questionId = utils.getNextQuestionId(sectionId, groupIndex);
    const type = document.querySelector(`[name="groupType_${sectionId}_${groupIndex}"]`).value;

    createQuestion(sectionId, groupIndex, questionId, type, false);
    updateQuestionNumbers(sectionId, groupIndex, false);
    return questionId;
}

function addSingleQuestion(groupIndex) {
    const questionId = utils.getSingleNextQuestionId(groupIndex);
    const type = document.querySelector(`[name="groupType_${groupIndex}"]`).value;

    createQuestion(groupIndex, groupIndex, questionId, type, true);
    updateQuestionNumbers(null, groupIndex, true);
    return questionId;
}

function createQuestion(sectionId, groupIndex, questionId, type, isSingle) {
    const prefix = isSingle ? '' : `${sectionId}_`;
    const containerId = isSingle ?
            `single-questions-container-${groupIndex}` :
            `questions-container-${sectionId}-${groupIndex}`;
    const questionElementId = isSingle ?
            `single-q-${groupIndex}-${questionId}` :
            `q-${sectionId}-${groupIndex}-${questionId}`;
    const removeFunc = isSingle ?
            `removeSingleQuestion(${groupIndex}, ${questionId})` :
            `removeListeningQuestion(${sectionId}, ${groupIndex}, ${questionId})`;

    const container = document.getElementById(containerId);
    let html = `
        <div class="question-block border p-3 position-relative mt-3 bg-light rounded" id="${questionElementId}">
            <button type="button" class="btn-close position-absolute end-0 top-0" onclick="${removeFunc}"></button>
            <h6>Question ${questionId}</h6>
    `;

    html += getQuestionTypeHTML(type, sectionId, groupIndex, questionId, isSingle);
    html += `</div>`;

    container.insertAdjacentHTML("beforeend", html);

// ✅ Đợi DOM gắn xong rồi mới thêm nội dung mặc định
    setTimeout(() => {
        addDefaultContent(type, sectionId, groupIndex, questionId, isSingle);
    }, 0);
    addDefaultContent(type, sectionId, groupIndex, questionId, isSingle);
}
function getQuestionTypeHTML(type, sectionId, groupIndex, questionId, isSingle) {
    const prefix = isSingle ? '' : `${sectionId}_`;
    const fullId = isSingle
            ? `single-${sectionId}-${questionId}`
            : `${sectionId}-${groupIndex}-${questionId}`;
    const singlePrefix = isSingle ? 'single-' : '';

    switch (type) {
        case "MULTIPLE_CHOICE":
            return `
                <label>Question Text:</label>
                <input type="text" name="q_${isSingle ? `${groupIndex}_${questionId}` : `${sectionId}_${groupIndex}_${questionId}`}" class="form-control mb-2" placeholder="Enter question text" required>
                <div id="${isSingle ? `single-options_${groupIndex}_${questionId}` : `options_${sectionId}_${groupIndex}_${questionId}`}"></div>
                <button type="button" class="btn btn-sm btn-outline-secondary mt-2"
                    onclick="${isSingle
                    ? `addSingleOption(${groupIndex}, ${questionId})`
                    : `addListeningOption(${sectionId}, ${groupIndex}, ${questionId})`}">
                    ➕ Add Option
                </button>
            `;

        case "MATCHING":
            return `
                <div id="${singlePrefix}matching-pairs-${prefix}${questionId}"></div>
                <button type="button" class="btn btn-sm btn-outline-primary mt-2"
                    onclick="${isSingle
                    ? `addSingleMatchingPair(${groupIndex}, ${questionId})`
                    : `addMatchingPair(${sectionId}, ${groupIndex}, ${questionId})`}">
                    ➕ Add Matching Pair
                </button>
            `;

        case "SUMMARY_COMPLETION":
        case "TABLE_COMPLETION":
        case "FLOWCHART":
        case "FORM_COMPLETION":
        case "NOTE_COMPLETION":
            return `
<div id="${isSingle ? `single-completion-lines-${groupIndex}-${questionId}` : `completion-lines-${sectionId}-${groupIndex}-${questionId}`}"></div>                <button type="button" class="btn btn-sm btn-outline-primary mt-2"
                    onclick="${isSingle
                    ? `addSingleCompletionLine(${groupIndex}, ${questionId})`
                    : `addCompletionLine(${sectionId}, ${groupIndex}, ${questionId})`}">
                    ➕ Add Completion Line
                </button>
            `;

        case "MAP_LABELING":
        case "PLAN_LABELING":
        case "DIAGRAM_LABELING":
            return `
                <label>Label ${questionId}:</label>
                <input type="text" name="labelQ_${isSingle ? `${groupIndex}_${questionId}` : `${sectionId}_${questionId}`}" class="form-control mb-2" placeholder="Enter label text" required>
                <label>Correct Answer:</label>
                <input type="text" name="labelA_${isSingle ? `${groupIndex}_${questionId}` : `${sectionId}_${questionId}`}" class="form-control" placeholder="Enter correct answer" required>
            `;

        case "SENTENCE_COMPLETION":
            return `
                <label>Sentence ${questionId}:</label>
                <input type="text" name="sentenceQ_${isSingle ? `${groupIndex}_${questionId}` : `${sectionId}_${questionId}`}" class="form-control mb-2" placeholder="Enter sentence with blank" required>
                <label>Correct Answer:</label>
                <input type="text" name="sentenceA_${isSingle ? `${groupIndex}_${questionId}` : `${sectionId}_${questionId}`}" class="form-control" placeholder="Enter correct answer" required>
            `;

        default:
            return `
                <label>Question ${questionId}:</label>
                <input type="text" name="q_${prefix}${questionId}" class="form-control mb-2" placeholder="Enter question text" required>
                <label>Answer:</label>
                <input type="text" name="shortA_${prefix}${questionId}" class="form-control" placeholder="Enter correct answer" required>
            `;
    }
}
function addDefaultContent(type, sectionId, groupIndex, questionId, isSingle) {
    switch (type) {
        case "MULTIPLE_CHOICE":
            for (let i = 0; i < 4; i++) {
                if (isSingle) {
                    addSingleOption(groupIndex, questionId);
                } else {
                    addListeningOption(sectionId, groupIndex, questionId);
                }
            }
            break;
        case "MATCHING":
            if (isSingle) {
                addSingleMatchingPair(groupIndex, questionId);
            } else {
                addMatchingPair(sectionId, groupIndex, questionId);
            }
            break;
        case "SUMMARY_COMPLETION":
        case "TABLE_COMPLETION":
        case "FLOWCHART":
        case "FORM_COMPLETION":
        case "NOTE_COMPLETION":
            if (isSingle) {
                addSingleCompletionLine(groupIndex, questionId);
            } else {
                addCompletionLine(sectionId, groupIndex, questionId);
            }
            break;
    }
}

// Option management functions
function addListeningOption(sectionId, groupIndex, questionId) {
    addOption(`options_${sectionId}_${groupIndex}_${questionId}`, `${sectionId}_${groupIndex}_${questionId}`, false);
}

function addSingleOption(groupIndex, questionId) {
    addOption(`single-options_${groupIndex}_${questionId}`, `${groupIndex}_${questionId}`, true);
}

function addOption(containerId, prefix, isSingle) {
    const container = document.getElementById(containerId);
    if (!container) {
        console.error(`Container not found: ${containerId}`);
        return;
    }
    const index = container.children.length || 0;
    const removeFunc = 'removeListeningOption(this)';

    const optHtml = `
        <div class="row mb-2 option-row align-items-center">
            <div class="col-md-6">
                <input type="text" name="a_${prefix}_${index}" class="form-control" placeholder="Option ${String.fromCharCode(65 + index)}" required>
            </div>
            <div class="col-md-2 d-flex align-items-center">
                <input class="form-check-input me-1" type="checkbox" name="correct_${prefix}_${index}">
                <label class="form-check-label ms-1">Correct</label>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="${removeFunc}">🗑 Remove</button>
            </div>
        </div>
    `;

    container.insertAdjacentHTML("beforeend", optHtml);
}

// Matching pair functions
function addMatchingPair(sectionId, groupIndex, questionId) {
    addMatchingPairContent(`matching-pairs-${sectionId}-${groupIndex}-${questionId}`, `${sectionId}_${groupIndex}_${questionId}`, false);
}

function addSingleMatchingPair(groupIndex, questionId) {
    addMatchingPairContent(`single-matching-pairs-${groupIndex}-${questionId}`, `${groupIndex}_${questionId}`, true);
}

function addMatchingPairContent(containerId, prefix, isSingle) {
    const container = document.getElementById(containerId);
    if (!container) {
        console.error(`Container not found: ${containerId}`);
        return;
    }
    const index = container.children.length || 0;
    const removeFunc = 'removeMatchingPair(this)';

    const pairHtml = `
        <div class="row mb-2 matching-pair align-items-center">
            <div class="col-md-5">
                <input type="text" name="matchQ_${prefix}_${index}" class="form-control" placeholder="Left item" required>
            </div>
            <div class="col-md-5">
                <input type="text" name="matchA_${prefix}_${index}" class="form-control" placeholder="Right item" required>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="${removeFunc}">🗑 Remove</button>
            </div>
        </div>
    `;

    container.insertAdjacentHTML("beforeend", pairHtml);
}

// Completion line functions
function addCompletionLine(sectionId, groupIndex, questionId) {
    addCompletionLineContent(`completion-lines-${sectionId}-${groupIndex}-${questionId}`, `${sectionId}_${groupIndex}_${questionId}`, false);
}

function addSingleCompletionLine(groupIndex, questionId) {
    addCompletionLineContent(`single-completion-lines-${groupIndex}-${questionId}`, `${groupIndex}_${questionId}`, true);
}
function addCompletionLineContent(containerId, prefix, isSingle) {
    const container = document.getElementById(containerId);
    if (!container) {
        console.error(`Container not found: ${containerId}`);
        return;
    }

    const questionId = container.children.length + 1; // giả định mỗi group chỉ có 1 question, nếu nhiều thì phải truyền vào
    const removeFunc = 'removeCompletionLine(this)';

    const lineHtml = `
        <div class="row mb-2 completion-line align-items-center">
            <div class="col-md-8">
                <input type="text" name="q_${prefix}${questionId}" class="form-control" placeholder="Question/Text with blank" required>
            </div>
            <div class="col-md-3">
                <input type="text" name="shortA_${prefix}${questionId}" class="form-control" placeholder="Answer" required>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="${removeFunc}">🗑</button>
            </div>
        </div>
    `;

    container.insertAdjacentHTML("beforeend", lineHtml);
}


// Remove functions
function removeListeningOption(btn) {
    btn.closest('.option-row')?.remove();
}

function removeMatchingPair(btn) {
    btn.closest('.matching-pair')?.remove();
}

function removeCompletionLine(btn) {
    btn.closest('.completion-line')?.remove();
}

function removeSingleQuestion(groupIndex, questionId) {
    const element = document.getElementById(`single-q-${groupIndex}-${questionId}`);
    if (element) {
        element.remove();
        updateQuestionNumbers(null, groupIndex, true);
    }
}

function removeListeningQuestion(sectionId, groupIndex, questionId) {
    const element = document.getElementById(`q-${sectionId}-${groupIndex}-${questionId}`);
    if (element) {
        element.remove();
        state.listeningQuestionCounts[sectionId][groupIndex] =
                state.listeningQuestionCounts[sectionId][groupIndex].filter(id => id !== questionId);
        updateQuestionNumbers(sectionId, groupIndex, false);
    }
}

function getQuestionNumber(sectionId, groupIndex, questionId) {
    const arr = state.listeningQuestionCounts[sectionId][groupIndex];
    return arr.indexOf(questionId) + 1;
}

function updateQuestionNumbers(sectionId, groupIndex, isSingle) {
    let containerId;
    if (isSingle) {
        containerId = `single-questions-container-${groupIndex}`;
    } else {
        containerId = `questions-container-${sectionId}-${groupIndex}`;
    }
    const container = document.getElementById(containerId);
    if (!container)
        return;
    const questionBlocks = container.querySelectorAll('.question-block');
    questionBlocks.forEach((block, idx) => {
        const h6 = block.querySelector('h6');
        if (h6)
            h6.textContent = `Question ${idx + 1}`;
    });
}

// Initialize the form when page loads
window.onload = () => {
    const examType = document.getElementById('examType');
    if (examType) {
        examType.addEventListener('change', function () {
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
