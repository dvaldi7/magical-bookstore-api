<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Book;
use App\Models\Secret;

class SecretSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $updatedBooks = [
            [
                "book_id" => 1,
                "description" => "The first #### of spellcasting is not #####, but intent. A ######## word with pure ####### will always overcome a shouted ########### filled with ####."
            ],
            [
                "book_id" => 8,
                "description" => "The ghost ###### blooms only at midnight during the autumn #######, its ###### collecting ######## that can later be harvested for illumination ######."
            ],
            [
                "book_id" => 11,
                "description" => "The strongest ######## are not those that deceive the ####, but those that whisper truths to the ##### that the #### is eager to ######."
            ],
            [
                "book_id" => 14,
                "description" => "All ###### yearns to be something else. The ######## merely listens to these ######## and facilitates the object's true ######."
            ],
            [
                "book_id" => 19,
                "description" => "Anchoring your physical #### before projection is essential. Three drops of #### on silver ensures your ###### can find its way ####."
            ],
            [
                "book_id" => 29,
                "description" => "A true ##### is not cast in anger but in #######. It should provide opportunity for #########, lest it rebound upon the caster #######."
            ]
        ];
        
        $secrets = [
            [
                "book_id" => 1,
                "words" => ["rule", "power", "whispered", "purpose", "incantation", "doubt"]
            ],
            [
                "book_id" => 8,
                "words" => ["orchid", "equinox", "petals", "moonlight", "spells"]
            ],
            [
                "book_id" => 11,
                "words" => ["illusions", "eyes", "heart", "mind", "believe"]
            ],
            [
                "book_id" => 14,
                "words" => ["matter", "alchemist", "whispers", "desire"]
            ],
            [
                "book_id" => 19,
                "words" => ["form", "blood", "spirit", "home"]
            ],
            [
                "book_id" => 29,
                "words" => ["curse", "balance", "redemption", "threefold"]
            ]
        ];

        foreach ($updatedBooks as $data) {
            Book::where('id', $data['book_id'])->update([
                'description' => $data['description']
            ]);
        }

        foreach ($secrets as $secretData) {
            Secret::create([
                'book_id' => $secretData['book_id'],
                'words' => json_encode($secretData['words']) // Guardar como texto en la DB
            ]);
        }
    }
}
