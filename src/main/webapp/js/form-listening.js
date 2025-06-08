let listeningSectionCount = 0;

function addListeningSection() {
    listeningSectionCount++;
    const container = document.getElementById("sections-container");

    const sectionDiv = document.createElement("div");
    sectionDiv.className = "section-box";
    sectionDiv.innerHTML = `
        <h3>🎧 Section ${listeningSectionCount}</h3>
        <input type="text" name="sectionTitle${listeningSectionCount}" placeholder="Section Title" required><br/>
        <textarea name="sectionContent${listeningSectionCount}" placeholder="Section Content" rows="3" required></textarea><br/>
        <div class="questions" id="questions_s${listeningSectionCount}"></div>
        <button type="button" onclick="addListeningQuestion(${listeningSectionCount})">➕ Add Question</button>
        <hr/>
    `;
    container.appendChild(sectionDiv);
}

function addListeningQuestion(sectionId) {
    const container = document.getElementById(`questions_s${sectionId}`);
    const qNum = container.children.length + 1;
    const qId = `s${sectionId}_q${qNum}`;

    const div = document.createElement("div");
    div.className = "question-box";
    div.innerHTML = `
        <h4>❓ Question ${qNum}</h4>
        <select name="type_${qId}">
            <option value="MULTIPLE_CHOICE">Multiple Choice</option>
            <option value="FORM_COMPLETION">Form Completion</option>
            <option value="SUMMARY_COMPLETION">Summary Completion</option>
            <option value="TABLE_COMPLETION">Table Completion</option>
            <option value="MAP_LABELING">Map Labeling</option>
            <option value="FLOWCHART">Flowchart</option>
        </select><br/>

        <textarea name="instruction_${qId}" placeholder="Instruction (optional)" rows="1"></textarea><br/>

        <label>Upload Image (optional):</label><br/>
        <input type="file" name="image_${qId}"/><br/>

        <label>Questions:</label><br/>
        <div id="questionText_${qId}"></div>
        <button type="button" onclick="addInput('${qId}', 'questionText')">➕ Add Question</button><br/>

        <label>Answers:</label><br/>
        <div id="answers_${qId}"></div>
        <button type="button" onclick="addInput('${qId}', 'answers')">➕ Add Answer</button><br/>
        <hr/>
    `;
    container.appendChild(div);
    addInput(qId, "questionText");
    addInput(qId, "answers");
}

function addInput(qId, type) {
    const wrapper = document.getElementById(`${type}_${qId}`);
    const count = wrapper.querySelectorAll("input").length;
    const input = document.createElement("input");
    input.type = "text";
    input.name = `${type}_${qId}_i${count}`;
    input.placeholder = `${type.includes("question") ? "Question" : "Answer"} ${count + 1}`;
    input.style = "margin-bottom:5px;width:90%";
    wrapper.appendChild(input);
    wrapper.appendChild(document.createElement("br"));
}

window.onload = function () {
    addListeningSection();
};
