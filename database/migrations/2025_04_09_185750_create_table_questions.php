<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('questions', function (Blueprint $table) {
            $table->integer('id')->primary()->autoIncrement();
            $table->string('question', 255);
            $table->string('answer', 100);
            $table->timestamps();
        });

        // import data from JSON questions file
        $json = file_get_contents(database_path('../Application/MariaDB/questions.json'));
        $questions = json_decode($json, true);

        foreach ($questions['questions'] as $question) {
            DB::table('questions')->insert([
                'question' => $question['question'],
                'answer' => $question['answer'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('questions');
    }
};
