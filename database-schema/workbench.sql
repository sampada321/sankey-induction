create database bike_db;

use  bike_db;
-- Create Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    user_type ENUM('admin', 'buyer', 'seller', 'both') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Bikes Table
CREATE TABLE Bikes (
    bike_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    brand VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    year INT,
	price DECIMAL(10, 2) NOT NULL,
    images JSON,
    listed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sold_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Transactions Table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT,
    seller_id INT,
    bike_id INT,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    transaction_price DECIMAL(10, 2) NOT NULL,
    status ENUM('completed', 'pending', 'cancelled') NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES Users(user_id),
    FOREIGN KEY (seller_id) REFERENCES Users(user_id),
    FOREIGN KEY (bike_id) REFERENCES Bikes(bike_id)
);

-- Create Reviews Table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    transaction_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);

--insert newdata

DELIMITER $$

CREATE PROCEDURE InsertUser(
    IN p_username VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255),
    IN p_phone_number VARCHAR(20),
    IN p_address VARCHAR(255),
    IN p_user_type ENUM('admin', 'buyer', 'seller', 'both')
)
BEGIN
    INSERT INTO Users (username, email, password, phone_number, address, user_type)
    VALUES (p_username, p_email, p_password, p_phone_number, p_address, p_user_type);
END$$

DELIMITER ;

CALL InsertUser('john_doe', 'john@example.com', 'hashed_password_123', '1234567890', '123 Main St, City', 'buyer');

--get bikedata
DELIMITER $$

CREATE PROCEDURE GetBikesByUser(
    IN p_user_id INT
)
BEGIN
    SELECT bike_id, title, description, brand, model, year, price, listed_at
    FROM bikes
    WHERE user_id = p_user_id;
END$$

DELIMITER ;

CALL GetBikesByUser(1);  -- Replace 1 with the actual user_id of the seller

--insert bikedata
DELIMITER $$

CREATE PROCEDURE InsertBike(
    IN p_user_id INT,          -- The user ID (seller)
    IN p_title VARCHAR(255),    -- Title of the bike listing
    IN p_description TEXT,     -- Description of the bike
    IN p_brand VARCHAR(255),    -- Brand of the bike
    IN p_model VARCHAR(255),    -- Model of the bike
    IN p_year INT,             -- Year of manufacture
    IN p_price DECIMAL(10,2),   -- Asking price of the bike
    IN p_images JSON           -- JSON array of bike image URLs
)
BEGIN
    INSERT INTO Bikes (
        user_id,
        title,
        description,
        brand,
        model,
        year,
        price,
        images,
        listed_at
    )
    VALUES (
        p_user_id,
        p_title,
        p_description,
        p_brand,
        p_model,
        p_year,
        p_price,
        p_images,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;

CALL InsertBike(
    1,                                -- p_user_id: Assume the user ID is 1 (seller)
    'Mountain Bike',                  -- p_title: Bike title
    'A great mountain bike for outdoor adventures.', -- p_description
    'Trek',                           -- p_brand: Bike brand
    'Marlin 7',                       -- p_model: Bike model
    2023,                             -- p_year: Year of the bike
    1500.00,                          -- p_price: Price of the bike
    '[\"https://example.com/image1.jpg\", \"https://example.com/image2.jpg\"]' -- p_images: JSON array of image URLs
);


--update bikedata


--delete bikedata
DELIMITER $$

CREATE PROCEDURE DeleteBike(
    IN p_bike_id INT
)
BEGIN
    DELETE FROM Bikes
    WHERE bike_id = p_bike_id AND sold_at IS NULL;
END$$

DELIMITER ;

CALL DeleteBike(1);  -- Replace 1 with the actual bike_id you want to delete
--bike has been sold

DELIMITER $$

CREATE PROCEDURE CompleteTransaction(
    IN p_transaction_id INT,
    IN p_bike_id INT
)
BEGIN
    -- Start transaction
    START TRANSACTION;

    -- Update transaction status
    UPDATE Transactions
    SET status = 'completed', transaction_date = CURRENT_TIMESTAMP
    WHERE transaction_id = p_transaction_id;

    -- Update bike's sold status
    UPDATE Bikes
    SET sold_at = CURRENT_TIMESTAMP
    WHERE bike_id = p_bike_id;

    -- Commit transaction
    COMMIT;
END$$

DELIMITER ;

CALL CompleteTransaction(1, 3);  -- Complete the transaction for transaction_id 1 and bike_id 3

