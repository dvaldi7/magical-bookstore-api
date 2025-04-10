<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('books', function (Blueprint $table) {
            // Add the category_id column
            $table->Integer('category_id')->nullable()->after('id');


            $table->index('category_id');
            
            // Add the foreign key constraint
            $table->foreign('category_id')
                  ->references('id')
                  ->on('categories')
                  ->onDelete('set null'); // or 'cascade' if you want to delete books when category is deleted
        });        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('books', function (Blueprint $table) {
            // Drop the foreign key first
            $table->dropForeign(['category_id']);

            // Then drop the index
            $table->dropIndex(['category_id']);
            
            // Then drop the column
            $table->dropColumn('category_id');
        });
    }
};
