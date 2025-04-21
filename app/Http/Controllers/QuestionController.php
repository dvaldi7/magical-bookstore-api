<?php

namespace App\Http\Controllers;

use App\Models\Book;
use App\Models\Question;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class QuestionController extends Controller
{
    /**
     * Get a random question, optionally filtered by book ID.
     *
     * @param  GetRandomQuestionRequest  $request
     */
    public function getRandomQuestion(Request $request): JsonResponse
    {
        try {
            $bookId = $request->input('book_id');

            if (! $bookId) {
                return response()->json([
                    'message' => 'Book parameter is required',
                ], Response::HTTP_NOT_FOUND);
            }

            $book = Book::where('id', $bookId)->first();

            if (! $book) {
                return response()->json([
                    'message' => $book, // 'Book not found',
                ], Response::HTTP_NOT_FOUND);
            }

            $randomQuestion = Question::inRandomOrder()->first();

            if ($randomQuestion) {
                return response()->json([
                    'id' => $randomQuestion->id,
                    'question' => $randomQuestion->question,
                ], Response::HTTP_OK);
            }

            return response()->json([
                'message' => 'No questions found',
            ], Response::HTTP_NOT_FOUND);

        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'An error occurred while getting the question',
                'error' => $th->getMessage(),
            ], 500); // 500 = Internal Server Error
        }
    }

    public function validateAnswer(Request $request): JsonResponse
    {
        $bookId = $request->input('book_id');

        if (! $bookId) {
            return response()->json([
                'message' => 'Book parameter is required',
            ], Response::HTTP_NOT_FOUND);
        }

        $book = Book::where('id', $bookId)->first();

        if (! $book) {
            return response()->json([
                'message' => 'Book not found',
            ], Response::HTTP_NOT_FOUND);
        }

        $unlocked = 0;

        if ($unlocked === $book->status) {
            return response()->json([
                'message' => 'Book is already unlocked',
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $questionId = $request->input('question_id');

        if (! $questionId) {
            return response()->json([
                'message' => 'Question parameter is required',
            ], Response::HTTP_NOT_FOUND);
        }

        $answer = $request->input('answer');

        if (! $answer) {
            return response()->json([
                'message' => 'Answer parameter is required',
            ], Response::HTTP_NOT_FOUND);
        }

        $question = Question::where('id', $questionId)->first();

        if (! $question) {
            return response()->json([
                'message' => 'No questions found for the given criteria',
            ], Response::HTTP_NOT_FOUND);
        }

        if (strtolower($answer) !== strtolower($question->answer)) {
            return response()->json([
                'correct_answer' => $question->answer,
                'answer' => $answer,
                'message' => 'Incorrect answer',
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        try {
            $book->status = $unlocked;
            $book->save();

            return response()->json([
                'message' => 'Book unlocked successfully',
            ], Response::HTTP_OK);

        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Failed to unlock book or book not found/already unlocked',
                'error' => $th->getMessage(),
            ], Response::HTTP_NOT_FOUND);
        }

    }

    /**
     * Unlock a book by its ID.
     */
    public function unlockBook(Request $request): JsonResponse
    {
        try {
            $validatedData = $request->validate([
                'book_id' => 'required|integer|exists:books,id',
            ], [
                'book_id.required' => 'The param book ID is required.',
                'book_id.integer' => 'The param book ID must be an integer.',
                'book_id.exists' => 'The param selected book ID is invalid.',
            ]);

            $bookId = $validatedData['book_id'];

            $book = Book::findOrFail($bookId);

            if ($book->status === 1) {
                return response()->json([
                    'message' => 'Book is already locked',
                ], Response::HTTP_UNPROCESSABLE_ENTITY);
            }

            $book->status = 1;
            $book->save();

            return response()->json([
                'message' => 'Book unlocked successfully',
            ], Response::HTTP_OK);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Error de validación',
                'errors' => $e->validator->errors(),
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Failed to unlock book or book not found/already unlocked',
                'error' => $th->getMessage(),
            ], Response::HTTP_NOT_FOUND);
        }

    }
}
