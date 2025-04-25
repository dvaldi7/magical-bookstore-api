<?php

namespace App\Http\Controllers;

use App\Models\Book;
use App\Models\Secret;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class SecretController extends Controller
{
    public function showSecretWords(Request $request): JsonResponse
    {
        try {
            $bookId = $request->input('book_id');

            if (! $bookId) {
                return response()->json([
                    'message' => 'Book parameter is required',
                ], Response::HTTP_NOT_FOUND);
            }

            $book = Book::findOrFail($bookId);

            $secret = Secret::where('book_id', $bookId)->first();

            if (! $secret) {
                return response()->json([
                    'message' => 'Secret not found for this book',
                ], Response::HTTP_NOT_FOUND);
            }

            $words = json_decode($secret->words);

            return response()->json([
                'message' => 'Secret words retrieved successfully',
                'words' => $words,
            ], Response::HTTP_OK);

        } catch (Exception $e) {
            return response()->json([
                'message' => 'Book not found',
                'errors' => $e->validator->errors(),
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Book is not found',
            ], Response::HTTP_NOT_FOUND);
        }
    }
}
