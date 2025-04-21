<?php

use App\Http\Controllers\BookController;
use App\Http\Controllers\QuestionController;
use Illuminate\Support\Facades\Route;

Route::get('/books', [BookController::class, 'index']);
Route::get('/books/author', [BookController::class, 'searchByAuthor']);
Route::get('/books/title', [BookController::class, 'searchByTitle']);
Route::get('/books/{id}', [BookController::class, 'show']);

Route::get('/questions/random', [QuestionController::class, 'getRandomQuestion']);
Route::post('/questions/validate-answer', [QuestionController::class, 'validateAnswer']);
Route::post('/questions/unlock', [QuestionController::class, 'unlockBook']);
