-- Add bonus column to existing CamPackages table
ALTER TABLE CamPackages 
ADD bonus INT DEFAULT 0;

-- Update existing records with bonus values based on original hardcoded data
UPDATE CamPackages SET bonus = 0 WHERE camAmount = 1000;
UPDATE CamPackages SET bonus = 200 WHERE camAmount = 2000;
UPDATE CamPackages SET bonus = 400 WHERE camAmount = 4000;
UPDATE CamPackages SET bonus = 700 WHERE camAmount = 7000;

-- Verify the changes
SELECT * FROM CamPackages ORDER BY camAmount; 