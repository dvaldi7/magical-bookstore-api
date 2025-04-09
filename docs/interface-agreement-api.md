# Application Interface Agreement
This document establishes a clear contract between frontend and backend systems to ensure reliable communication for the Magical Books Api. It specifies.


## Endpoints

### 1. Get All Books
**Endpoint**: `GET /books`

**Response:** ✅ Success (200 OK)

```json
[
  {
    "id": 1,
    "title": "The Book of Forgotten Spells",
    "author": "Elara Moonshadow",
    "description": "The first rule of spellcasting is not power, but intent. A whispered word with pure purpose will always overcome a shouted incantation filled with doubt.",
    "status": 1
  },
  {
    "id": 2,
    "title": "Elemental Bindings",
    "author": "Thorne Emberwright",
    "description": "Fire responds not to command but to respect. Approach the flame with humility, and it shall dance within your palm without burning.",
    "status": 0
  },
]
```

**Response:** ⚠️ Error (404 Not Found)

```json
{
    "message": "No books found"
}
```

**Response:** ⚠️ Error (500 Internal Server Error)

```json
{
    "message": "An error occurred while fetching books",
    "error": "Database connection error"
}
```

### 2. Search Books by Author
**Endpoint:** `GET /books/author?author={author}`

**Response:** ✅ Success (200 OK)

```json
[
  {
    "id": 2,
    "title": "Elemental Bindings",
    "author": "Thorne Emberwright",
    "description": "Fire responds not to command but to respect. Approach the flame with humility, and it shall dance within your palm without burning.",
    "status": 0
  }
]
```

**Response:** ⚠️ Missing Parameter (400 Bad Request)

```json
{
  "message": "Author parameter is required"
}
```

**Response:** ⚠️ No Results (404 Not Found)**

```json
{
  "message": "No books found for the given criteria"
}
```

### 3. Search Books by Title
**Endpoint:** `GET /books/title?title={title}`

**Response:** ✅ Success (200 OK)

```json
[
  {
    "id": 2,
    "title": "Elemental Bindings",
    "author": "Thorne Emberwright",
    "description": "Fire responds not to command but to respect. Approach the flame with humility, and it shall dance within your palm without burning.",
    "status": 0
  }
]
```

**Response:** ⚠️ Missing Parameter (400 Bad Request)


```json
{
  "message": "Title parameter is required"
}
```

**Response:** ⚠️ No Results (404 Not Found)**

```json
{
  "message": "No books found for the given criteria"
}
```


### 4. Get Single Book
**Endpoint:** `GET /books/{id}`

**Responses:** ✅ Success (200 OK)**

```json
{
  "id": 1,
  "title": "The Book of Forgotten Spells",
  "author": "Elara Moonshadow",
  "description": "The first rule of spellcasting is not power, but intent. A whispered word with pure purpose will always overcome a shouted incantation filled with doubt.",
  "status": 1
}
```

**Response:** ⚠️ Not Found (404 Not Found)

```json
{
  "message": "Book not found"
}
```

## Notes
All responses are in JSON format

- Timestamps follow ISO 8601 format (UTC)
- Search endpoints perform partial matching
- Title search returns limited fields (id, title, author) for optimization
- Error responses include both user-friendly messages and technical details
- API not requires authentication (not shown in examples)
