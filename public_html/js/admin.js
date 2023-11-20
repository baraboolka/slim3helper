document.addEventListener("DOMContentLoaded", function(){
    /* show flash message if not empty */
    let adminAlertMessage = document.querySelector("#admin-main-alert-text");

    if( adminAlertMessage ){
        if( adminAlertMessage.innerHTML != '' ){
            document.querySelector("#admin-main-alert").classList.add("show");
        }
    }
    
    let adminAlertMessageClose = document.querySelector("#admin-main-alert-close");
    if( adminAlertMessageClose ){
        adminAlertMessageClose.addEventListener('click', function(){
            document.querySelector("#admin-main-alert").classList.remove("show");
        });
    }

    /* add pre + code tags in text-area */
    let contentFormHelperButton = document.querySelector("#content-form-helper-btn");
    if( contentFormHelperButton ){
        contentFormHelperButton.addEventListener("click", function(){
            let currentCursorPosition = document.querySelector("#content-form-helper-textarea").selectionStart;
            let currentTextarea = document.querySelector("#content-form-helper-textarea");
            
            currentTextarea.value =
            currentTextarea.value.substring(0, currentCursorPosition) + 
            '<pre><code class="language-' + 
            document.querySelector("#content-form-helper-list").value + 
            '">' + 
            '</code></pre>' + 
            currentTextarea.value.substring(currentCursorPosition);
        });
    }
})