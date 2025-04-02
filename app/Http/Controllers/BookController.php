<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\Request;

class BookController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {                
        try {
            $books = Book::all();
            
            if($books->isEmpty()) {
                return response()->json([
                    'message' => 'No books found'
                ], 404); // 404 = Not Found
            }

            return response()->json($books, 200); // 200 = OK

        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'An error occurred while fetching books',
                'error' => $th->getMessage()
            ], 500); // 500 = Internal Server Error
        }
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Book $book, $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Book $book)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Book $book)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Book $book)
    {
        //
    }
}
