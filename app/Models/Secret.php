<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Secret extends Model
{
    protected $table = 'secrets';
    protected $fillable = ['book_id', 'words'];
    public $timestamps = false;
}
