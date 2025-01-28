const fetchUsers = async () => {
    const url = 'https://jsonplaceholder.typicode.com/users';
    const response = await fetch(url);  // Fetch data 
    const users = await response.json();  // Parse the response as JSON
    renderUsers(users);  
};

const renderUsers = (users) => {
    const tableBody = document.getElementById('user-table-body');
    users.forEach(user => {
        const row = document.createElement('tr');
        
        const nameCell = document.createElement('td');
        nameCell.textContent = user.name;
        row.appendChild(nameCell);

        const usernameCell = document.createElement('td');
        usernameCell.textContent = user.username;
        row.appendChild(usernameCell);

        const emailCell = document.createElement('td');
        emailCell.textContent = user.email;
        row.appendChild(emailCell);

        const phoneCell = document.createElement('td');
        phoneCell.textContent = user.phone;
        row.appendChild(phoneCell);

        tableBody.appendChild(row);
    });
};

fetchUsers();
