function validateLogin(event) {
    event.preventDefault();  // Prevent the form from submitting the default way

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    const errorMsgUsername = document.getElementById('error-username');
    const errorMsgPassword = document.getElementById('error-password');

    // Clear previous error messages
    errorMsgUsername.textContent = '';
    errorMsgPassword.textContent = '';

    // Define the correct credentials
    const validUsername = 'sankey901@solutions.com';
    const validPassword = 'mindset';

    // Check if both username and password are correct
    if (username === validUsername && password === validPassword) {
        // If correct, redirect to the welcome page
        localStorage.setItem('username', 'Sankey');
        window.location.href = 'welcome.html'; 
    } else {
        // If either username or password is incorrect, display respective error messages
        if (username !== validUsername) {
            errorMsgUsername.textContent = 'Invalid username/email';
            errorMsgUsername.style.color = 'red';
        }
        if (password !== validPassword) {
            errorMsgPassword.textContent = 'Invalid password';
            errorMsgPassword.style.color = 'red';
        }
    }
}
