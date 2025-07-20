// Switch Section functionality for IELTS Listening Test
let currentActiveSection = 1;

function switchSection(sectionNumber) {
    currentActiveSection = sectionNumber;
    
    // Update active button styling
    document.querySelectorAll('.section-btns button').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Find and activate the clicked button
    const buttons = document.querySelectorAll('.section-btns button');
    if (buttons[sectionNumber - 1]) {
        buttons[sectionNumber - 1].classList.add('active');
    }
    
    // Update hidden input value
    const hiddenInput = document.getElementById('sectionHidden');
    if (hiddenInput) {
        hiddenInput.value = sectionNumber;
    }
    
    // Show/hide section containers
    document.querySelectorAll('.section-container').forEach(container => {
        container.style.display = 'none';
    });
    
    const targetContainer = document.getElementById(`section-container-${sectionNumber}`);
    if (targetContainer) {
        targetContainer.style.display = 'block';
    }
    
    console.log(`Switched to Section ${sectionNumber}`);
}

// Initialize section switching when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Set first section as active by default
    switchSection(1);
    
    // Add click event listeners to section buttons
    document.querySelectorAll('.section-btns button').forEach((button, index) => {
        button.addEventListener('click', function() {
            switchSection(index + 1);
        });
    });
});

// Function to get current active section
function getCurrentSection() {
    return currentActiveSection;
}

// Function to validate section data before submission
function validateSectionData() {
    const examType = document.getElementById('examType').value;
    
    if (examType === 'LISTENING_FULL') {
        // Validate that at least one section has data
        let hasData = false;
        for (let i = 1; i <= 4; i++) {
            const sectionTitle = document.querySelector(`[name="sectionTitle${i}"]`);
            
            if (sectionTitle && sectionTitle.value.trim() !== '') {
                hasData = true;
                break;
            }
        }
        
        if (!hasData) {
            alert('Please fill in at least one section with title.');
            return false;
        }
    } else if (examType === 'LISTENING_SINGLE') {
        // Validate single section data
        const sectionTitle = document.getElementById('sectionTitle');
        
        if (!sectionTitle.value.trim()) {
            alert('Please fill in section title for single section.');
            return false;
        }
    }
    
    return true;
}

// Add form validation before submission
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validateSectionData()) {
                e.preventDefault();
                return false;
            }
        });
    }
}); 