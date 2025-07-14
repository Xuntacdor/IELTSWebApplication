-- Create CamPackages table
CREATE TABLE CamPackages (
    id INT PRIMARY KEY IDENTITY(1,1),
    camAmount INT NOT NULL,
    price INT NOT NULL,
    label NVARCHAR(255),
    bonus INT DEFAULT 0
);

-- Insert sample data based on original hardcoded values
INSERT INTO CamPackages (camAmount, price, label, bonus) VALUES
(1000, 85000, '1000 CAM Package', 0),
(2000, 195000, '2000 CAM Package', 200),
(4000, 385000, '4000 CAM Package', 400),
(7000, 610000, '7000 CAM Package', 700);

-- Optional: Add more packages if needed
-- INSERT INTO CamPackages (camAmount, price, label, bonus) VALUES
-- (5000, 485000, '5000 CAM Package', 500),
-- (10000, 950000, '10000 CAM Package', 1000); 