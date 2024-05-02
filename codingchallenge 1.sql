CREATE DATABASE CodingChallenge

USE CodingChallenge


CREATE TABLE Artists(
 Artist_id INT PRIMARY KEY,
 [Name] VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100)
)

CREATE TABLE Categories(
 Category_id INT PRIMARY KEY ,
 [Name] VARCHAR(100) NOT NULL
)

CREATE TABLE Artworks(
 Artwork_id  INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 Artist_id INT,
 Category_id INT,
 [Year] INT,
 [Description] TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY(Artist_id) REFERENCES Artists(Artist_id),
 FOREIGN KEY(Category_id) REFERENCES Categories(Category_id)
)

CREATE TABLE Exhibitions(
 Exhibition_id INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT
)

CREATE TABLE ExhibitionArtworks (
 Exhibition_id INT,
 Artwork_id INT,
 PRIMARY KEY (Exhibition_id, Artwork_id),
 FOREIGN KEY (Exhibition_id) REFERENCES Exhibitions(Exhibition_id),
 FOREIGN KEY (Artwork_id) REFERENCES Artworks(Artwork_id)
)

INSERT INTO Artists (Artist_id, [Name], Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian')
SELECT * FROM Artists

INSERT INTO Categories (Category_id, [Name]) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography')
SELECT * FROM Categories

INSERT INTO Artworks (Artwork_id, Title, Artist_id, Category_id, [Year], [Description], ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso s powerful anti-war mural.', 'guernica.jpg')
SELECT * FROM Artworks

INSERT INTO Exhibitions (Exhibition_id, Title, StartDate, EndDate, [Description]) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.')
SELECT * FROM Exhibitions

INSERT INTO ExhibitionArtworks (Exhibition_id, Artwork_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2)
SELECT * FROM  Artists
SELECT * FROM Categories
SELECT * FROM Artworks
SELECT * FROM Exhibitions

----1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.

SELECT Artists.[Name], COUNT(Artworks.Artwork_id) AS ArtworkCount
FROM Artists
LEFT JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
GROUP BY Artists.Artist_id, Artists.[Name]
ORDER BY ArtworkCount DESC

----2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.

SELECT Artworks.Title, Artworks.[Year]
FROM Artworks
JOIN Artists ON Artworks.Artist_id = Artists.Artist_id
WHERE Artists.Nationality IN ('Spanish', 'Dutch')
ORDER BY Artworks.[Year] ASC

----3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.

SELECT Artists.[Name], COUNT(*) AS Artwork_Count
FROM Artists
JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
JOIN Categories ON Artworks.Category_id = Categories.Category_id
WHERE Categories.[Name] = 'Painting'
GROUP BY Artists.[Name]

----4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.

SELECT Artworks.Title AS Artwork_Name, Artists.[Name] AS Artist, Categories.[Name] AS Category
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.Artwork_id = ExhibitionArtworks.Artwork_id
JOIN Artists ON Artworks.Artist_id = Artists.Artist_id
JOIN Categories ON Artworks.Category_id = Categories.Category_id
JOIN Exhibitions ON ExhibitionArtworks.Exhibition_id = Exhibitions.Exhibition_id
WHERE Exhibitions.Title = 'Modern Art Masterpieces'

----5. Find the artists who have more than two artworks in the gallery.

SELECT Artists.[Name], COUNT(Artworks.Artwork_id) AS [no.of artworks]
FROM Artists
JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
GROUP BY Artists.Artist_id, Artists.[Name]
HAVING COUNT(Artworks.Artwork_id) > 2;

----6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions

SELECT A.Title
 FROM Artworks A
 JOIN ExhibitionArtworks EA ON A.Artwork_id = EA.Artwork_id
 JOIN Exhibitions E ON EA.Exhibition_id = E.Exhibition_id
 WHERE E.Exhibition_id IN (
  SELECT Exhibition_id
   FROM Exhibitions
   WHERE Title = 'Modern Art Masterpieces'
   )
 AND E.Exhibition_id IN (
   SELECT Exhibition_id
   FROM Exhibitions
   WHERE Title = 'Renaissance Art'
 )

----7. Find the total number of artworks in each category

SELECT Categories.[Name] AS Category_Name, COUNT(Artworks.Artwork_id) AS Total_Artworks
FROM Categories
LEFT JOIN Artworks ON Categories.Category_id = Artworks.Category_id
GROUP BY Categories.[Name]

----8. List artists who have more than 3 artworks in the gallery.

SELECT Artists.Artist_id, Artists.[Name], COUNT(Artworks.Artwork_id) AS [no. of artworks]
FROM Artists
JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
GROUP BY Artists.Artist_id, Artists.[Name]
HAVING COUNT(Artworks.Artwork_id) > 3;

----9. Find the artworks created by artists from a specific nationality 

SELECT Artists.[Name] AS Artist_Name, Artworks.Title AS Artwork_Title, Artists.Nationality
FROM Artists
INNER JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
WHERE Artists.Nationality = 'Spanish'

----10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci. 
SELECT e.Title AS Exhibition_Name
FROM Exhibitions e
JOIN ExhibitionArtworks ea ON e.Exhibition_id = ea.Exhibition_id
JOIN Artworks a ON ea.Artwork_id = a.Artwork_id
JOIN Artists [at] ON a.Artist_id = [at].Artist_id
JOIN Artists av ON a.Artist_id = av.Artist_id
WHERE ([at].[Name] = 'Vincent van Gogh' OR av.[Name] = 'Vincent van Gogh')
AND ([at].[Name] = 'Leonardo da Vinci' OR av.[Name] = 'Leonardo da Vinci')


----11. Find all the artworks that have not been included in any exhibition.
SELECT *
 FROM Artworks
 WHERE Artwork_id NOT IN (SELECT Artwork_id FROM ExhibitionArtworks)



----13. List the total number of artworks in each category.
SELECT Categories.Name AS Category, COUNT(Artworks.Artwork_id) AS TotalArtworks
 FROM Categories
 LEFT JOIN Artworks ON Categories.Category_id = Artworks.Category_id
 GROUP BY Categories.Name

----14. Find the artists who have more than 2 artworks in the gallery.
SELECT Artists.Artist_id, Artists.[Name], COUNT(Artworks.Artwork_id) AS ArtworkCount
 FROM Artists
 JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
 GROUP BY Artists.Artist_id, Artists.[Name]
 HAVING COUNT(Artworks.Artwork_id) > 2

----15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
SELECT c.[Name] AS Category_Name, COUNT(a.Artwork_id) AS [no. of artworks], AVG(a.[Year]) AS Avg_Year
 FROM Categories c
 JOIN Artworks a ON c.Category_id = a.Category_id
 GROUP BY c.Category_id, c.[Name]
 HAVING COUNT(a.Artwork_id) > 1

----16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT Title FROM Artworks
WHERE Artwork_id IN (
 SELECT Artwork_id
  FROM ExhibitionArtworks
  WHERE Exhibition_id = (
   SELECT Exhibition_id
   FROM Exhibitions
   WHERE Title = 'Modern Art Masterpieces'
  )
)



----18. List the artworks that were not exhibited in any exhibition.
SELECT Artwork_id, Title
FROM Artworks
WHERE Artwork_id NOT IN (SELECT Artwork_id FROM ExhibitionArtworks)

----19. Show artists who have artworks in the same category as "Mona Lisa."
SELECT  Artists.Artist_id, Artists.Name, Artists.Nationality
 FROM Artists
 JOIN Artworks ON Artists.Artist_id = Artworks.Artist_id
 WHERE Artworks.Category_id = (
  SELECT Category_id FROM Artworks
  WHERE Title = 'Mona Lisa'
)

----20. List the names of artists and the number of artworks they have in the gallery.
SELECT A.Name AS ArtistName, COUNT(*) AS [no. of Artworks]
FROM Artists A
JOIN Artworks AW ON A.Artist_id = AW.Artist_id
GROUP BY A.Name




