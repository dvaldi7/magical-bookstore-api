<?php

use App\Http\Controllers\BookController;
use Illuminate\Support\Facades\Route;

Route::get('/', [BookController::class, 'index']);
Route::get('/books/author', [BookController::class, 'searchByAuthor']);
Route::get('/books/title', [BookController::class, 'searchByTitle']);
Route::get('/books/{id}', [BookController::class, 'show']);